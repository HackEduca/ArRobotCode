//
//  LevelsRepository.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 30/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import Alamofire

class LevelsRepository: Repository {
    private var entities: [DataLevel] = []
    
    private var entitiesBehaviourSubject: BehaviorSubject<[DataLevel]> = BehaviorSubject(value: [])
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    let realm = try! Realm()
    
    public let dataSource: Observable<[DataLevel]>
    
    init() {
        dataSource = entitiesBehaviourSubject.asObservable()
        syncWithDataFromLocal()
        syncWithDataFromServer()
        syncChangedDataToServer()
    }
    
    func getAll() -> [DataLevel] {
        return self.entities;
    }
    
    func get(Name: String) -> DataLevel? {
        for entity in self.entities {
            if entity.Name == Name {
                return entity
            }
        }

        return nil
    }
    
    func getAt(Name: String) -> Int {
        var at = 0;
        for entity in self.entities {
            if entity.Name == Name {
                return at
            }
            
            at += 1
        }
        
        return -1
    }
    
    func get(at: Int) -> DataLevel {
        if(at < 0) {
             return DataLevel()
        }
        
        return self.entities[at]
    }
    
    func add(a: DataLevel) -> Bool {
        // Edit local
        self.entities.append(a)
            
        // Edit on server
        try! self.realm.write {
            let ual = UnsyncedLevel()
            ual.name = a.Name
            ual.level = a
            ual.operation = "add"
            realm.add(ual)
        }
            
        self.entitiesBehaviourSubject.onNext(self.entities)
        self.syncDataToLocalStorage()

        return true
    }
    
    func update(a: DataLevel) -> Bool {
        var ok: Bool = false
        try! self.realm.write {
            for i in 0..<self.entities.count{
                if self.entities[i].Name == a.Name {
                    // Edit local
                    self.entities[i] = a
                    self.entitiesBehaviourSubject.onNext(self.entities)
                    
                    // Edit on server
                    try! self.realm.write {
                        let ual = UnsyncedLevel()
                        ual.name = a.Name
                        ual.level = a
                        ual.operation = "update"
                        realm.add(ual)
                    }
                    
                    ok = true
                    break
                }
            }
            
        }
        
        if ok {
            return true
        }
        return false
    }
    
    func update(at: Int, newDataLevel: DataLevel) {
        try! self.realm.write {
            if(at >= 0) {
                // Edit local
                self.entities[at] = newDataLevel
                self.entitiesBehaviourSubject.onNext(self.entities)
                
                // Edit on server
                try! self.realm.write {
                    let ual = UnsyncedLevel()
                    ual.name = newDataLevel.Name
                    ual.level = newDataLevel
                    ual.operation = "update"
                    realm.add(ual, update: true)
                }
            }
        }
    }
    
    func triggerUpdate(at: Int) {

        // Edit on server
        try! self.realm.write {
            let ual = UnsyncedLevel()
            ual.name = self.entities[at].Name
            ual.level = self.entities[at]
            ual.operation = "update"
            realm.add(ual, update: true)
        }
    }
    
    func delete(Name: String) -> Bool {
        for i in 0..<self.entities.count{
            if self.entities[i].Name == Name {
                // Delete local
                let entityToBeDeleted: DataLevel = self.entities[i]
                self.entities.remove(at: i)
                self.entitiesBehaviourSubject.onNext(self.entities)
                
                // Delete on server
                try! self.realm.write {
                    let ual = UnsyncedLevel()
                    ual.name = entityToBeDeleted.Name
                    ual.level = entityToBeDeleted
                    ual.operation = "delete"
                    realm.add(ual, update: true)
                }
                
                return true
            }
        }
        return false
    }
    
    func delete(at: Int) -> Bool {
        // Delete local
         let entityToBeDeleted: DataLevel = self.entities[at]
        self.entities.remove(at: at)
        self.entitiesBehaviourSubject.onNext(self.entities)
        
        // Delete on server
        try! self.realm.write {
            let ual = UnsyncedLevel()
            ual.name = entityToBeDeleted.Name
            ual.level = entityToBeDeleted
            ual.operation = "delete"
            realm.add(ual)
        }
        return true
    }
    
    
    private func syncWithDataFromLocal() {
        realm.objects(DataLevel.self).forEach { (el) in
            self.entities.append(el);
            self.entitiesBehaviourSubject.onNext(self.entities)
        }
    }
    
    private func syncWithDataFromServer() {
        let obs: Observable<APIResponse>
        let rq = LevelsRequest()
        
        obs = self.apiClient.send(apiRequest: rq)
        obs.subscribe { (entries) in
            if let ent = entries.element {
                if ent.code == "200" {
                    // Delete request from local queue
                    print("Synced with data from server: OK")
                    self.entities = ent.data
                    self.entitiesBehaviourSubject.onNext(self.entities)
                } else {
                     print(ent.msg)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func syncChangedDataToServer() {
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        Observable<Int>
            .interval(5.0, scheduler: concurrentScheduler)
            .subscribe({ ev in
                
            // Loop through all unsynced levels and try to add them
                do {
                    let realm = try Realm()
                    realm.objects(UnsyncedLevel.self).forEach { (a) in
                        switch a.operation {
                        case "add":
                            self.syncAddToServer(a: a)
                        case "update":
                            self.syncUpdateToServer(a: a)
                        case "delete":
                            self.syncDeleteToServer(a: a)
                        default:
                            break
                        }
                    }
                }
                catch {
                    
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func syncAddToServer(a: UnsyncedLevel) {
        let levelThreadSafeRef = ThreadSafeReference(to: a)
        
        let jsonEncoder = JSONEncoder()
        var json: String = ""
        do {
            let jsonData = try jsonEncoder.encode(a.level)
            json = String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print("Enconding object to json failed")
            return
        }
        
        // Send the post request
        Alamofire.request("https://domino.serveo.net/levels", method: .post, parameters: [:], encoding: json, headers: [:])
            .responseJSON { res in
                if(res.error == nil) {
                    do {
                        let almoRealm = try Realm()
                        let lvl = almoRealm.resolve(levelThreadSafeRef)
                        try! almoRealm.write {
                            // Delete the level from unsynced added level
                            print(lvl!.name, " deleted from unsynced added data queue")
                            almoRealm.delete(lvl!)
                        }
                    } catch {
                        
                    }
                }
        }
    }
    
    
    private func syncDeleteToServer(a: UnsyncedLevel) {
        let levelThreadSafeRef = ThreadSafeReference(to: a)
        
        Alamofire
            .request("https://domino.serveo.net/levels/" + a.name,  method: .delete, headers: [:])
            .responseJSON { res in
                if(res.error == nil) {
                    do {
                        let almoRealm = try Realm()
                        let lvl = almoRealm.resolve(levelThreadSafeRef)
                        try! almoRealm.write {
                            // Delete the level from unsynced added level
                            print(lvl!.name, " deleted from unsynced deleted data queue")
                            almoRealm.delete(lvl!)
                        }
                    } catch {
                        
                    }
                }
        }
    }
    
    private func syncUpdateToServer(a: UnsyncedLevel) {
        let levelOriginalName = a.name
        let levelThreadSafeRef = ThreadSafeReference(to: a)
        
        let jsonEncoder = JSONEncoder()
        var json: String = ""
        do {
            let jsonData = try jsonEncoder.encode(a.level)
            json = String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print("Enconding object to json failed")
            return
        }
        
        // Send the post request
        Alamofire.request("https://domino.serveo.net/levels/" + levelOriginalName, method: .put, parameters: [:], encoding: json, headers: [:])
            .responseJSON { res in
                if(res.error == nil) {
                    do {
                        let almoRealm = try Realm()
                        let lvl = almoRealm.resolve(levelThreadSafeRef)
                        try! almoRealm.write {
                            // Delete the level from unsynced added level
                            print(lvl!.name, " deleted from unsynced update data queue")
                            almoRealm.delete(lvl!)
                        }
                    } catch {
                        
                    }
                }
        }
    }
    
    private func syncDataToLocalStorage() {
        for entity in entities {
            try! realm.write {
                realm.add(entity)
            }
        }
    }

}
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
