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
        syncAddedDataToServer()
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
        self.entities.append(a)
            
        // Add object to unsynced
        try! self.realm.write {
            var ual = UnsyncedAddedLevel()
            ual.name = a.Name
            ual.level = a
            realm.add(ual)
        }
            
        self.entitiesBehaviourSubject.onNext(self.entities)
        self.syncDataToLocalStorage()

        return true
    }
    
    func update(a: DataLevel) -> Bool {
        var ok: Bool = false
        do {
            try! self.realm.write {
                for i in 0..<self.entities.count{
                    if self.entities[i].Name == a.Name {
                        self.entities[i] = a
                        self.entitiesBehaviourSubject.onNext(self.entities)
                        ok = true
                    }
                }
                
            }
        } catch {
            
        }
        
        if ok {
            return true
        }
        return false
    }
    
    func update(at: Int, newDataLevel: DataLevel) {
        do {
            try! self.realm.write {
                if(at >= 0) {
                    self.entities[at] = newDataLevel
                    self.entitiesBehaviourSubject.onNext(self.entities)
                }
            }
        } catch {
            
        }
        
    }
    
    func delete(Name: String) -> Bool {
        for i in 0..<self.entities.count{
            if self.entities[i].Name == Name {
                self.syncDeletedDataToServer(Name: Name)
                self.entities.remove(at: i)
                self.entitiesBehaviourSubject.onNext(self.entities)
                return true
            }
        }
        return false
    }
    
    func delete(at: Int) -> Bool {
        self.syncDeletedDataToServer(at: at)
        self.entities.remove(at: at)
        self.entitiesBehaviourSubject.onNext(self.entities)
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
            print("Intrat")
            if let ent = entries.element {
                print(ent)
                if ent.code == "200" {
                    // Delete request from local queue
                    print("Server response: OK")
                    self.entities = ent.data
                    self.entitiesBehaviourSubject.onNext(self.entities)
                } else {
                     print(ent.msg)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func syncAddedDataToServer() {
        Observable<Int>.interval(5.0, scheduler: MainScheduler.instance).subscribe({ ev in
            // Loop through all unsynced levels and try to add them
            self.realm.objects(UnsyncedAddedLevel.self).forEach { (a) in
                
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
                Alamofire.request("https://domino.serveo.net/levels?", method: .post, parameters: [:], encoding: json, headers: [:])
                    .responseJSON { res in
                        if(res.error == nil) {
                            try! self.realm.write {
                                // Delete the level from unsynced added level q
                                print(a.name, " deleted from unsynced added data queue")
                                self.realm.delete(a)
                            }
                        }
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func syncDeletedDataToServer(at: Int) {
        syncDeletedDataToServer(Name: self.entities[at].Name )
    }
    
    private func syncDeletedDataToServer(Name: String) {
        let obs: Observable<APIResponse>
        let rq = LevelsRequest()
        rq.path = "levels/" + Name
        rq.method = RequestType.DELETE
        
        obs = self.apiClient.send(apiRequest: rq)
        obs.subscribe { (entries) in
            if let ent = entries.element {
                if ent.code == "200" {
                    // Delete request from local queue
                    print("Server response: OK")
                } else {
                    print(ent.msg)
                }
            }
            }.disposed(by: disposeBag)
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
