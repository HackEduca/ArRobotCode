//
//  Achievement.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 18/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

class Achievement: Codable {
    @objc dynamic  var ID: String = ""
    @objc dynamic  var Description: String = ""
    @objc dynamic  var Name: String = ""
    @objc dynamic  var Picture: String = "default.png"
    
    private enum CodingKeys: String, CodingKey {
       case Description
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
