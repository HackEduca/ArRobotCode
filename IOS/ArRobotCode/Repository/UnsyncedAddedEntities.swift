//
//  UnsyncedAddedEntities.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 27/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RealmSwift

class UnsyncedLevel: Object {
    @objc dynamic var name = ""
    @objc dynamic var operation = ""
    @objc dynamic var level: DataLevel?
    
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}
