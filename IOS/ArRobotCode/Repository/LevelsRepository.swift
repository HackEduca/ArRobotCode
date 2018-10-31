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
    
    public let dataSource: Observable<[DataLevel]>
    
    init() {
        dataSource = entities.asObservable()
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
                self.entities.value.remove(at: i)
                return true
            }
        }
        return false
    }
    
    func delete(at: Int) -> Bool {
        self.entities.value.remove(at: at)
        return true
    }
}
