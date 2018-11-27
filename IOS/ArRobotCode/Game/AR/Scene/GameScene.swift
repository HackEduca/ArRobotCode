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
    let TILE_SIZE: Float = 0.15
    
    var scene: SCNScene?
    var game: SCNNode?
    var tile: SCNNode?
    
    var player: SCNNode?
    public var playerController: PlayerAR!
    
    init() {
        scene = self.initializeScene()
        game = self.initializeNode(name: "game")
        tile = self.initializeNode(name: "tile")
        player = self.initializeNode(name: "player")
        self.playerController = PlayerAR(player: self.player!, tileSize: TILE_SIZE)
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
        let N = level.Height;
        let M = level.Width;
        
        // Find the start position && center everything from it
        var pos = game?.position
        var index = 0
        for i in 0...N - 1 {
            for j in 0...M - 1 {
                if level.Tiles[index].Type == TypeOfTile.Start.rawValue {
                    pos!.x -= TILE_SIZE * Float(j)
                    pos!.z -= TILE_SIZE * Float(i)
                }
                
                index += 1
            }
        }
        var crtPos = pos
        
        // Generate all the tiles
        index = 0
        for _ in 1...N {
            for _ in 1...M {
                // Create a new tile
                let newTile = deepCopyNode(node: tile!)
                newTile.setValue(index, forKey: "index")
                newTile.position = crtPos!
                newTile.isHidden = false
                
                // Set color && hidden state
                switch level.Tiles[index].Type {
                    case TypeOfTile.Start.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIColor.yellow
                    
                    case TypeOfTile.Finish.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIColor.green
                    
                    case TypeOfTile.Used.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIColor.red
                    
                    default:
                        newTile.isHidden = true
                }

                // Add the tile
                self.scene?.rootNode.addChildNode(newTile)
                
                // Prepare for the next one
                crtPos?.x += TILE_SIZE
                index += 1
            }
            crtPos?.x = (pos?.x)!
            crtPos?.z += TILE_SIZE
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

