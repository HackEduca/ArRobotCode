//
//  Character.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

class Character: Codable {
    @objc dynamic  var ID: String = ""
    @objc dynamic  var LevelsRequired: Int = 0
    @objc dynamic  var Name: String = ""
    @objc dynamic  var Picture: String = "default.png"
    
    private enum CodingKeys: String, CodingKey {
        case LevelsRequired
        case Name
        case Picture
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
