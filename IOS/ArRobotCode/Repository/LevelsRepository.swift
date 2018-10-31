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

class LevelsRepository: Repository {
    private var entities: Variable<[DataLevel]> = Variable([])
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    public let dataSource: Observable<[DataLevel]>
    
    init() {
        dataSource = entities.asObservable()
        syncWithDataFromLocal()
        syncWithDataFromServer()
    }
    
    func getAll() -> [DataLevel] {
        return self.entities.value
    }
    
    func get(Name: String) -> DataLevel? {
        for entity in self.entities.value {
            if entity.Name == Name {
                return entity
            }
        }
        
        return nil
    }
    
    func add(a: DataLevel) -> Bool {
        self.entities.value.append(a)
        syncAddedDataToServer(a: a)
        return true
    }
    
    func update(a: DataLevel) -> Bool {
        for i in 0..<self.entities.value.count{
            if self.entities.value[i].Name == a.Name {
                self.entities.value[i] = a
                return true
            }
        }
        
        return false
    }
    
    func delete(Name: String) -> Bool {
        for i in 0..<self.entities.value.count{
            if self.entities.value[i].Name == Name {
                self.syncDeletedDataToServer(Name: Name)
                self.entities.value.remove(at: i)
                return true
            }
        }
        return false
    }
    
    func delete(at: Int) -> Bool {
        self.syncDeletedDataToServer(at: at)
        self.entities.value.remove(at: at)
        return true
    }
    
    private func syncWithDataFromLocal() {
        
    }
    
    private func syncWithDataFromServer() {
        let obs: Observable<APIResponse>
        let rq = LevelsRequest()
        
        obs = self.apiClient.send(apiRequest: rq)
        obs.subscribe { (entries) in
            if var ent = entries.element {
                if ent.code == "200" {
                    // Delete request from local queue
                    print("Server response: OK")
                    self.entities.value = ent.data
                } else {
                     print(ent.msg)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func syncAddedDataToServer(a: DataLevel) {
        // Encode a to JSON string
        // To do: refactor this
        let jsonEncoder = JSONEncoder()
        var json: String = ""
        do {
           let jsonData = try jsonEncoder.encode(a)
           json = String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print("Very big problem")
            return
        }
        
        // Build the request
        let obs: Observable<APIResponse>
        let rq = LevelsRequest()
        rq.method = RequestType.POST
        rq.httpBody = json
        
        // Send it and wait for confirmation
        obs = self.apiClient.send(apiRequest: rq)
        obs.subscribe { (entries) in
            if var ent = entries.element {
                if ent.code == "200" {
                    // Delete request from local queue
                    print("Server response: OK")
                } else {
                    print(ent.msg)
                }
            }
            print(entries)
        }.disposed(by: disposeBag)
    }
    
    private func syncDeletedDataToServer(at: Int) {
        syncDeletedDataToServer(Name: self.entities.value[at].Name )
    }
    
    private func syncDeletedDataToServer(Name: String) {
        let obs: Observable<APIResponse>
        let rq = LevelsRequest()
        rq.path = "levels/" + Name
        rq.method = RequestType.DELETE
        
        obs = self.apiClient.send(apiRequest: rq)
        obs.subscribe { (entries) in
            if var ent = entries.element {
                if ent.code == "200" {
                    // Delete request from local queue
                    print("Server response: OK")
                } else {
                    print(ent.msg)
                }
            }
            }.disposed(by: disposeBag)
    }
    

}
