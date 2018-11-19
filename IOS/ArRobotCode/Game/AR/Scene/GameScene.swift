//
//  GameSceneViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 15/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import Foundation
import SceneKit

struct GameScene {
    var scene: SCNScene?
    var game: SCNNode?
    var tile: SCNNode?
    
    init() {
        scene = self.initializeScene()
        game = self.initializeNode(name: "game")
        tile = self.initializeNode(name: "tile")
    }
    
    func initializeScene() -> SCNScene? {
        let scene = SCNScene(named: "art.scnassets/game.scn")!
        setDefaults(scene: scene)
        
        return scene
    }
    
    func initializeNode(name: String) -> SCNNode? {
        var foundNode: SCNNode? = nil
        self.scene!.rootNode.enumerateChildNodes { (node, _) in
            if node.name == name {
                foundNode = node
            }
        }
        return foundNode
    }
    
    
    func setDefaults(scene: SCNScene) {
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLight.LightType.ambient
        ambientLightNode.light?.color = UIColor(white: 0.6, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Create a directional light with an angle to provide a more interesting look
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.color = UIColor(white: 0.8, alpha: 1.0)
        directionalLight.shadowRadius = 5.0
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.6)
        directionalLight.castsShadow = true
        directionalLight.shadowMode = .deferred
        let directionalNode = SCNNode()
        directionalNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-40), GLKMathDegreesToRadians(0), GLKMathDegreesToRadians(0))
        directionalNode.light = directionalLight
        scene.rootNode.addChildNode(directionalNode)
    }
    
    func addText(string: String, parent: SCNNode, position: SCNVector3 = SCNVector3Zero) {
        guard let scene = self.scene else { return }
        
        let textNode = self.createTextNode(string: string)
        textNode.position = scene.rootNode.convertPosition(position, to: parent)
        
        parent.addChildNode(textNode)
    }
    
    func createTextNode(string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        textNode.castsShadow = true
        
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        (minVec, maxVec) =  textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation(
            minVec.x + (maxVec.x - minVec.x)/2,
            minVec.y,
            minVec.z + (maxVec.z - minVec.z)/2
        )
        return textNode
    }
    
    func setGamePosition(pos: SCNVector3) {
        self.game?.position = pos
    }
    
    func easeOutElastic(_ t: Float) -> Float {
        let p: Float = 0.3
        let result = pow(2.0, -10.0 * t) * sin((t - p / 4.0) * (2.0 * Float.pi) / p) + 1.0
        return result
    }
    
    func spawnLevel(level: DataLevel) {
        // Will initialise
//        var heightBB = self.player!.boundingBox.max.x - self.player!.boundingBox.min.x
//        var widthBB  = self.player!.boundingBox.max.y - self.player!.boundingBox.min.y
//
//        print("Height: ", heightBB, " Width: ", widthBB)
        
        var N = 10;
        var M = 10;
        var tileSize: Float = 0.15;
        
        var pos = game?.position
        pos!.x -= tileSize * Float(N / 2)
        pos!.z -= tileSize * Float(N / 2)
        var crtPos = pos
        
        var index = 0
        for i in 1...N {
            for j in 1...M {
                // Create a new tile
                var newTile = deepCopyNode(node: tile!)
                newTile.position = crtPos!
                newTile.isHidden = false
                
                // Set color && hidden state
                switch level.Tiles[index].type {
                    case TypeOfTile.Start.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIColor.yellow
                    
                    case TypeOfTile.Finish.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIColor.yellow
                    
                    case TypeOfTile.Used.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIColor.red
                    
                    default:
                        newTile.isHidden = true
                }

                // Add the tile
                game?.addChildNode(newTile)
                
                // Prepare for the next one
                crtPos?.z += tileSize
                index += 1
            }
            crtPos?.z = (pos?.z)!
            crtPos?.x += tileSize
        }
    }
    
    fileprivate func deepCopyNode(node: SCNNode) -> SCNNode {
        let clone = node.clone()
        clone.geometry = node.geometry?.copy() as? SCNGeometry
        if let g = node.geometry {
            clone.geometry?.materials = g.materials.map{ $0.copy() as! SCNMaterial }
        }
        return clone
    }

}

