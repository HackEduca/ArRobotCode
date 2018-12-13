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
    @objc dynamic  var Width:  Int = 0
    @objc dynamic  var Height: Int = 0
    @objc dynamic  var Public: Bool = false
    @objc dynamic  var Order:  Int = 0
    @objc dynamic  var Chapter: String = ""
    
    var Tiles: [DataTile] = []
    
    static func comparer(lhs: DataLevel, rhs: DataLevel) -> Bool {
        return lhs.Name == rhs.Name
    }
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case UUID
        case Width
        case Height
        case Public
        case Order
        case Chapter
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
    
    public func setPublic(newPublic: Bool) {
        self.Public = newPublic
    }
    
    public func setOrder(newOrder: Int) {
        self.Order = newOrder
    }
    
    public func setChapter(newChapter: String) {
        self.Chapter = newChapter
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
