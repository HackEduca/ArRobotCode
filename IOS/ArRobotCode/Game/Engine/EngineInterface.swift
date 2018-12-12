//
//  EngineInterface.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 22/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

protocol EngineInterface{
    func isValid() -> Bool
    func isDone() -> Bool
    func resetLevel()
}
