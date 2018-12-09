//
//  RepositoryProtocol.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 30/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func get(Name: String) -> T?
    func get(at: Int) -> T
    func add(a: T) -> Bool
    func update(a: T) -> Bool
    func delete(Name: String) -> Bool
    func triggerUpdate(at: Int)
    
}
