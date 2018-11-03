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
}

class DataTile: Codable {
    var type: TypeOfTile
    
    init(){
        self.type = .Free
    }
    
    init(type: TypeOfTile) {
        self.type = type
    }
    
    func swap() {
        if type == .Free {
            type = .Used
            return
        }
        
        if type == .Used {
            type = .Free
            return
        }
        
        if type == .Start {
            type = .Finish
            return
        }
        
        type = .Free
        return
    }
    
    func setToStart() {
        type = .Start
    }
    
    func setToFinish() {
        type = .Finish
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
    
}
