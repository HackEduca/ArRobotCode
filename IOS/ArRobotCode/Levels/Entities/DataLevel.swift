//
//  DataLevel.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 30/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

class DataLevel: Codable {
    var Name: String = ""
    var Width: Int = 0
    var Height: Int = 0
    var Tiles: [DataTile] = []
    
    init() {
        
    }
    
    init(Name: String, Width: Int, Height: Int, Tiles: [DataTile] ) {
        self.Name   = Name
        self.Width  = Width
        self.Height = Height
        self.Tiles  = Tiles
    }
    
    init(Name: String, Width: Int, Height: Int) {
        self.Name   = Name
        self.Width  = Width
        self.Height = Height
    }
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case Width
        case Height
        case Tiles
    }
}
