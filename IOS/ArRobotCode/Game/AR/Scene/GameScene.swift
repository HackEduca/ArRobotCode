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
import ARKit

struct GameScene {
    var TILE_SIZE: Float = 70
    
    var scene: SCNScene?
    var customRoot: SCNNode?
    var tile: SCNNode?
    
    var player: SCNNode?
    var playerRoot: SCNNode?
    
    var planeAnchor: ARPlaneAnchor? // plane that the scene will stand on

    public var playerController: PlayerAR!
    
    init() {
        scene = self.initializeScene()
        
        customRoot = self.initializeNode(name: "customRoot")
        tile = self.initializeNode(name: "tile")
        player = self.initializeNode(name: "player")
        playerRoot = self.initializeNode(name: "playerRoot")
        self.playerController = PlayerAR(player: self.player!, tileSize: TILE_SIZE)
        
        self.customRoot!.scale = SCNVector3(0.001, 0.001, 0.001)
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
    
    mutating func setGamePosition(pos: SCNVector3, planeAnchor: ARPlaneAnchor) {
        self.customRoot?.position = pos
        self.planeAnchor = planeAnchor
    }
    
    func easeOutElastic(_ t: Float) -> Float {
        let p: Float = 0.3
        let result = pow(2.0, -10.0 * t) * sin((t - p / 4.0) * (2.0 * Float.pi) / p) + 1.0
        return result
    }
    
    mutating func spawnLevel(level: DataLevel) {
        // Scale ship & tiles
        let scaleX = ((self.planeAnchor?.extent.x)! * 0.97) / ( TILE_SIZE * Float(level.Width) );
        let scaleZ = ((self.planeAnchor?.extent.z)! * 0.97) / ( TILE_SIZE * Float(level.Height) );
        self.customRoot?.scale = SCNVector3(min(scaleX, scaleZ), min(scaleX, scaleZ), min(scaleX, scaleZ))
        
        // Will initialise
        let N = level.Height;
        let M = level.Width;
        
        // Find the start position
        var pos = customRoot?.position
        pos?.x -= TILE_SIZE * Float(M / 2)
        pos?.z -= TILE_SIZE * Float(N / 2)
        var crtPos = pos
        
        // Generate all the tiles
        var index = 0
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
                        playerRoot?.position.x = (crtPos?.x)!
                        playerRoot?.position.z = (crtPos?.z)!
                        newTile.geometry!.materials.first!.diffuse.contents  = UIImage(named: "pink")
                    
                    case TypeOfTile.Finish.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIImage(named: "yellow")
                    
                    case TypeOfTile.Used.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents = UIImage(named: "green")
                    
                    case TypeOfTile.UsedA.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents  = UIImage(named: "greenA")
                    
                    case TypeOfTile.UsedB.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents = UIImage(named: "greenB")
                    
                    case TypeOfTile.UsedC.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents = UIImage(named: "greenC")
                    
                    case TypeOfTile.UsedD.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents = UIImage(named: "greenD")
                    
                    case TypeOfTile.UsedE.rawValue:
                        newTile.geometry!.materials.first!.diffuse.contents = UIImage(named: "greenE")
                    
                    default:
                            newTile.isHidden = true
                }

                // Add the tile
                self.customRoot!.addChildNode(newTile)
                
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

