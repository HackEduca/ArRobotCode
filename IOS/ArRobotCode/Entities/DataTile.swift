//
//  DataTile.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 26/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import UIKit

enum TypeOfTile: Int, Codable {
    case Free
    case Used
    case Start
    case Finish
    case UsedA
    case UsedB
    case UsedC
    case UsedD
    case UsedE
}

class DataTile: Codable {
    @objc dynamic var `Type`: Int = 0
    
    func swap() {
        if Type == TypeOfTile.Free.rawValue {
            Type = TypeOfTile.Used.rawValue
            return
        }
        
        if Type == TypeOfTile.Used.rawValue {
            Type = TypeOfTile.Free.rawValue
            return
        }
        
        if Type == TypeOfTile.Start.rawValue {
            Type = TypeOfTile.Finish.rawValue
            return
        }
        
        Type = TypeOfTile.Free.rawValue
        return
    }
    
    func cycleLeft() {
        if(Type == TypeOfTile.Free.rawValue || Type == TypeOfTile.Start.rawValue || Type == TypeOfTile.Finish.rawValue) {
            return
        }
        
        if(Type == TypeOfTile.Used.rawValue) {
            Type = TypeOfTile.UsedE.rawValue
            return
        }
        
        if(Type == TypeOfTile.UsedA.rawValue) {
            Type = TypeOfTile.Used.rawValue
            return
        }
        
        if(Type > TypeOfTile.UsedA.rawValue  && Type <= TypeOfTile.UsedE.rawValue) {
            Type -= 1
        }
    }
    
    func cycleRight() {
        if(Type == TypeOfTile.Free.rawValue || Type == TypeOfTile.Start.rawValue || Type == TypeOfTile.Finish.rawValue) {
            return
        }
        
        if(Type == TypeOfTile.Used.rawValue) {
            Type = TypeOfTile.UsedA.rawValue
            return
        }
        
        if(Type == TypeOfTile.UsedE.rawValue) {
            Type = TypeOfTile.Used.rawValue
            return
        }
        
        if(Type >= TypeOfTile.UsedA.rawValue  && Type < TypeOfTile.UsedE.rawValue) {
            Type += 1
        }
    }
    
    func setToFree() {
      Type = TypeOfTile.Free.rawValue
    }
    
    func setToStart() {
        Type = TypeOfTile.Start.rawValue
    }
    
    func setToFinish() {
        Type = TypeOfTile.Finish.rawValue
    }
    
}
