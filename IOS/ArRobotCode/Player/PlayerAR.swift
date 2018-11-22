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
        let refNodeTransform = matrix_float4x4(player.transform)
        
        // Combine translation with ref node
        let newPositionPlayer = SCNNode()
        newPositionPlayer.transform = SCNMatrix4Translate(player.transform, 0.0, 0.0, self.tileSize)
        
        // Do the animation
        let moveFrontAction = SCNAction.move(to: newPositionPlayer.position, duration: 1)
        player.runAction(moveFrontAction)
    }
    
    func moveBack() {
        let refNodeTransform = matrix_float4x4(player.transform)
        
        // Combine translation with ref node
        let newPositionPlayer = SCNNode()
        newPositionPlayer.transform = SCNMatrix4Translate(player.transform, 0.0, 0.0, -self.tileSize)
        
        // Do the animation
        let moveBackAction = SCNAction.move(to: newPositionPlayer.position, duration: 1)
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

extension SCNMatrix4 {
    func position() -> SCNVector3 {
        return SCNVector3(m31, m32, m33)
    }
}

extension SCNVector3 {
    init(_ vector: float4) {
        self.init(x: vector.x / vector.w, y: vector.y / vector.w, z: vector.z / vector.w)
    }
}
