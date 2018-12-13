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
import Alamofire
import Firebase

class LevelsRepository: Repository {
    public let dataSource: Observable<[DataLevel]>
    
    private var entities: [DataLevel] = []
    private var entitiesBehaviourSubject: BehaviorSubject<[DataLevel]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()

    
    let db: Firestore!
    
    
    init() {
        dataSource = entitiesBehaviourSubject.asObservable()
        self.db = Firestore.firestore()
        
        // Start sync process
        syncFromServer()
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
            if entity.UUID == ID {
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
        
        // Add on firebase
        self.syncAddtoServer(a: a)
        
        // Propagate changes
        self.entitiesBehaviourSubject.onNext(self.entities)
        
        return true
    }
    
    func update(a: DataLevel) -> Bool {
        var ok: Bool = false
        for i in 0..<self.entities.count{
            if self.entities[i].UUID == a.UUID {
                // Update local
                self.entities[i] = a
                self.entitiesBehaviourSubject.onNext(self.entities)
                
                // Update on server
                self.syncUpdateToServer(a: self.entities[i])
                
                ok = true
                break
            }
        }
        
        if ok {
            return true
        }
        return false
    }
    
    func update(at: Int, newDataLevel: DataLevel) {
        if(at >= 0) {
            // Edit local
            self.entities[at] = newDataLevel
            self.entitiesBehaviourSubject.onNext(self.entities)
            
            // Edit on server
            self.syncUpdateToServer(a: self.entities[at])
        }
    }
    
    func triggerUpdate(at: Int) {
        if(at >= 0) {
            self.entitiesBehaviourSubject.onNext(self.entities)
            self.syncUpdateToServer(a: self.entities[at])
        }
    }
    
    func delete(Name: String) -> Bool {
        for i in 0..<self.entities.count{
            if self.entities[i].Name == Name {
                // Delete local
                let UUID = self.entities[i].UUID
                self.entities.remove(at: i)
                self.entitiesBehaviourSubject.onNext(self.entities)
                
                // Delete on server
                self.syncDeleteToServer(UUID: UUID)
                return true
            }
        }
        return false
    }
    
    func delete(at: Int) -> Bool {
        // Delete local
        let UUID = self.entities[at].UUID
        self.entities.remove(at: at)
        self.entitiesBehaviourSubject.onNext(self.entities)
        
        // Delete on server
        self.syncDeleteToServer(UUID: UUID)
        return true
    }
    

    private func syncFromServer() {
        let docRef = db.collection("levels")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let level = try JSONDecoder().decode(DataLevel.self, withJSONObject: document.data(), options: [])
                        self.entities.append(level)
                        self.entitiesBehaviourSubject.onNext(self.entities)
                    } catch {
                        
                    }
                    
                }
            }
        }
    }
    
    private func syncAddtoServer(a: DataLevel) {
        do { 
            self.db.collection("levels").document(a.UUID).setData(try a.asDictionary())
        } catch {
            
        }
    }
    
    private func syncUpdateToServer(a: DataLevel) {
        do {
            var dict = try a.asDictionary()
            print(dict)
            self.db.collection("levels").document(a.UUID).updateData(try a.asDictionary())
        } catch {
            
        }
    }
    
    private func syncDeleteToServer(UUID: String) {
         self.db.collection("levels").document(UUID).delete()
    }
    
}

extension JSONEncoder {
    func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
