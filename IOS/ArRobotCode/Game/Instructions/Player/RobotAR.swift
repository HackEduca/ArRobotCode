//
//  RobotAR.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 20/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import ARKit

class PlayerAR: PlayerInterface {
    var player: SCNNode!
    var tileSize: Int
    
    init(player: SCNNode, tileSize: Int) {
        self.player = player
        self.tileSize = tileSize
    }
    
    func moveFront(distanceInMM distance: Int) {
      
    }
    
    func moveBack(distanceInMM distance: Int) {
       
    }
    
    func turnLeft() {
       let rotateLeft = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi / 2), z: 0, duration: 2)
       player.runAction(rotateLeft)
    }
    
    func turnRight() {
        let rotateRight = SCNAction.rotateBy(x: 0, y: CGFloat(-Float.pi / 2), z: 0, duration: 2)
        player.runAction(rotateRight)
    }
    
}
