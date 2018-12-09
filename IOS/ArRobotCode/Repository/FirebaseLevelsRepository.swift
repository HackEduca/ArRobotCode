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

class FirebaseLevelsRepository: Repository {
    public let dataSource: Observable<[DataLevel]>
    
    
    private var entities: [DataLevel] = []
    private var entitiesBehaviourSubject: BehaviorSubject<[DataLevel]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    
    init() {
        dataSource = entitiesBehaviourSubject.asObservable()
        syncFromLocal()
        syncWithDataFromServer()
    }
    
    func getAll() -> [DataLevel] {
        return self.entities;
    }
    
    func getPublic() -> [DataLevel] {
        return self.entities
    }
    
    func get(Name: String) -> DataLevel? {
        for entity in self.entities {
            if entity.Name == Name {
                return entity
            }
        }
        
        return nil
    }
    
    func getAt(ID: String) -> Int {
        var at = 0;
        for entity in self.entities {
            if entity.ID == ID {
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
        
        
        self.entitiesBehaviourSubject.onNext(self.entities)
        self.syncToLocal()
        
        return true
    }
    
    func update(a: DataLevel) -> Bool {
        var ok: Bool = false
        try! self.realm.write {
            for i in 0..<self.entities.count{
                if self.entities[i].ID == a.ID {
                    // Edit local
                    self.entities[i] = a
                    self.entitiesBehaviourSubject.onNext(self.entities)
                    
                    // Edit on server
                    
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
                
                
            }
        }
    }
    
    func triggerUpdate(at: Int) {
        
    }
    
    func delete(Name: String) -> Bool {
        for i in 0..<self.entities.count{
            if self.entities[i].Name == Name {
                // Delete local
                let entityToBeDeleted: DataLevel = self.entities[i]
                self.entities.remove(at: i)
                self.entitiesBehaviourSubject.onNext(self.entities)
                
                // Delete on server
                
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

        return true
    }
    
    
    private func syncFromLocal() {
        realm.objects(DataLevel.self).forEach { (el) in
            self.entities.append(el);
            self.entitiesBehaviourSubject.onNext(self.entities)
        }
    }
    
    private func syncWithDataFromServer() {
        // To do
    }
    
    private func syncToLocal() {
        for entity in entities {
            try! realm.write {
                realm.add(entity)
            }
        }
    }
    
}
