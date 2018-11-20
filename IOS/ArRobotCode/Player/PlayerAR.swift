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
    var tileSize: Float
    
    init(player: SCNNode, tileSize: Float) {
        self.player = player
        self.tileSize = tileSize
    }
    
    func moveFront() {
        let moveFrontAction = SCNAction.moveBy(x: 0, y: 0, z: CGFloat(tileSize), duration: 1)
        player.runAction(moveFrontAction)
    }
    
    func moveBack() {
        let moveBackAction = SCNAction.moveBy(x: 0, y: 0, z: CGFloat(-tileSize), duration: 1)
        player.runAction(moveBackAction)
    }
    
    func turnLeft() {
       let rotateLeftAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi / 2), z: 0, duration: 1)
       player.runAction(rotateLeftAction)
    }
    
    func turnRight() {
        let rotateRightAction = SCNAction.rotateBy(x: 0, y: CGFloat(-Float.pi / 2), z: 0, duration: 1)
        player.runAction(rotateRightAction)
    }
    
}
