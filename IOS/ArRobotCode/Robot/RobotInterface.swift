//
//  RobotInterface.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 23/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

protocol RobotInterface {
    func moveFront  (distanceInMM distance: Int)
    func moveBack   (distanceInMM distance: Int)
    func rotateLeft   ()
    func rotateRight  ()
}
