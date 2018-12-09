//
//  DataLevel.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 30/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

class DataLevel: Codable {
    @objc dynamic  var UUID: String = NSUUID().uuidString
    @objc dynamic  var Name: String = ""
    @objc dynamic  var Width: Int = 0
    @objc dynamic  var Height: Int = 0
    var Tiles: [DataTile] = []
    
    static func comparer(lhs: DataLevel, rhs: DataLevel) -> Bool {
        return lhs.Name == rhs.Name
    }
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case UUID
        case Width
        case Height
        case Tiles
    }
    
    public func setName(newName: String) {
        self.Name = newName
    }
    
    public func setWidth(newWidth: Int) {
        self.Width = newWidth
        self.reAssignTiles()
    }
    
    public func setHeight(newHeight: Int) {
        self.Height = newHeight
        self.reAssignTiles()
    }
    
    private func reAssignTiles(){
        let tiles: [DataTile] = []
        for i in 0 ..< self.Tiles.count {
            self.Tiles[i].Type = TypeOfTile.Free.rawValue
        }
        
        while self.Tiles.count > (self.Width * self.Height) {
            self.Tiles.removeLast()
        }
        while self.Tiles.count < (self.Width * self.Height){
            self.Tiles.append(DataTile())
        }
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }

        return dictionary
    }

}
