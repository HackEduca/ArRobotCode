//
//  UserProperties.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 12/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

class UserProperties: Codable {
     @objc dynamic  var Role: String = ""
     @objc dynamic  var RegisterDate: Int = 0
    @objc dynamic   var SelectedCharacter: String = ""
    
    
    private enum CodingKeys: String, CodingKey {
        case Role
        case RegisterDate
        case SelectedCharacter
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
