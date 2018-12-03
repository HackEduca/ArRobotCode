//
//  DataLevel.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 30/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RealmSwift

class DataLevel: Object, Codable {
    @objc dynamic  var Name: String = ""
    @objc dynamic  var Width: Int = 0
    @objc dynamic  var Height: Int = 0
    var Tiles = List<DataTile>()
    
    static func comparer(lhs: DataLevel, rhs: DataLevel) -> Bool {
        return lhs.Name == rhs.Name
    }
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case Width
        case Height
        case Tiles
    }
    
    public func setName(newName: String) {
        do {
            let realm = try! Realm()
            try! realm.write {
                self.Name = newName
            }
        } catch {
            
        }
    }
    
    public func setWidth(newWidth: Int) {
        do {
            let realm = try! Realm()
            try! realm.write {
                self.Width = newWidth
                self.reAssignTiles()
            }
        } catch {
            
        }
    }
    
    public func setHeight(newHeight: Int) {
        do {
            let realm = try! Realm()
            try! realm.write {
                self.Height = newHeight
                self.reAssignTiles()
            }
        } catch {
            
        }
    }
    
    private func reAssignTiles(){
        let tiles: List<DataTile> = List<DataTile>()
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
}

extension List : Decodable where Element : Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    } }

extension List : Encodable where Element : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    } }
