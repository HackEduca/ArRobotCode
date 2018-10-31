//
//  LevelsRequest.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 31/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

class LevelsRequest: APIRequest {
    var method = RequestType.GET
    var path = "levels"
    var parameters = [String: String]()
    var httpBody: String = ""
    
    init() {
    }
}
