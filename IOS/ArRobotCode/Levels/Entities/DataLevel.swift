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
