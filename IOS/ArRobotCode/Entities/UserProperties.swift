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
    
    
    private enum CodingKeys: String, CodingKey {
        case Role
        case RegisterDate
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
