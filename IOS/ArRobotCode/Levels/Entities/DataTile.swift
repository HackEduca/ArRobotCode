//
//  DataTile.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 26/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

enum TypeOfTile: Int, Codable {
    case Free
    case Used
    case Start
    case Finish
}

class DataTile: Object, Codable {
    @objc dynamic var type: Int = 0
    
    func swap() {
        if type == TypeOfTile.Free.rawValue {
            type = TypeOfTile.Used.rawValue
            return
        }
        
        if type == TypeOfTile.Used.rawValue {
            type = TypeOfTile.Free.rawValue
            return
        }
        
        if type == TypeOfTile.Start.rawValue {
            type = TypeOfTile.Finish.rawValue
            return
        }
        
        type = TypeOfTile.Free.rawValue
        return
    }
    
    func setToStart() {
        type = TypeOfTile.Start.rawValue
    }
    
    func setToFinish() {
        type = TypeOfTile.Finish.rawValue
    }
    
}
