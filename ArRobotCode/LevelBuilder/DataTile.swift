//
//  DataTile.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 26/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import UIKit

enum StateOfTile {
    case Free
    case Used
    case Start
    case Finish
}
class DataTile {
    var state: StateOfTile
    
    init(){
        self.state = .Free
    }
    
    func swap() {
        if state == .Free {
            state = .Used
            return
        }
        
        if state == .Used {
            state = .Free
            return
        }
        
        if state == .Start {
            state = .Finish
            return
        }
        
        state = .Free
        return
    }
    
    func setToStart() {
        state = .Start
    }
    
    func setToFinish() {
        state = .Finish
    }
}
