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
        // Combine translation with ref node
        let updatedPlayer = -1 * self.player.simdWorldFront * self.tileSize

        // Do the animation
        let moveFrontAction = SCNAction.move(by: SCNVector3(updatedPlayer), duration: 1)
        player.runAction(moveFrontAction)
    }
    
    func moveBack() {
        // Combine translation with ref node
        let updatedPlayer = self.player.simdWorldFront * self.tileSize
        
        // Do the animation
        let moveBackAction = SCNAction.move(by: SCNVector3(updatedPlayer), duration: 1)
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

extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}
