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
    case UsedA
    case UsedB
    case UsedC
    case UsedD
    case UsedE
}

class DataTile: Object, Codable {
    @objc dynamic var `Type`: Int = 0
    
    func swap() {
        do {
            let realm = try! Realm()
            try! realm.write {
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
            }
        } catch {
            
        }
        
        return
    }
    
    func cycleLeft() {
        do {
            let realm = try! Realm()
            try! realm.write {
                if(Type == TypeOfTile.Free.rawValue || Type == TypeOfTile.Start.rawValue || Type == TypeOfTile.Finish.rawValue) {
                    return
                }
                
                if(Type == TypeOfTile.Used.rawValue) {
                    Type = TypeOfTile.UsedE.rawValue
                    return
                }
                
                if(Type > TypeOfTile.UsedA.rawValue  && Type <= TypeOfTile.UsedE.rawValue) {
                    Type -= 1
                }
            }
        } catch {
            
        }
    }
    
    func cycleRight() {
        do {
            let realm = try! Realm()
            try! realm.write {
                if(Type == TypeOfTile.Free.rawValue || Type == TypeOfTile.Start.rawValue || Type == TypeOfTile.Finish.rawValue) {
                    return
                }
                
                if(Type == TypeOfTile.Used.rawValue) {
                    Type = TypeOfTile.UsedA.rawValue
                    return
                }
                
                if(Type >= TypeOfTile.UsedA.rawValue  && Type < TypeOfTile.UsedE.rawValue) {
                    Type += 1
                }
            }
        } catch {
            
        }
    }
    
    func setToStart() {
        do {
            let realm = try! Realm()
            try! realm.write {
                Type = TypeOfTile.Start.rawValue
            }
        } catch {
            
        }
    }
    
    func setToFinish() {
        do {
            let realm = try! Realm()
            try! realm.write {
                Type = TypeOfTile.Finish.rawValue
            }
        } catch {
            
        }
    }
    
}
