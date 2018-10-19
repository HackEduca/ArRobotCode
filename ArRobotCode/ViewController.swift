//
//  ViewController.swift
//  ArRoboCode
//
//  Created by Sorin Sebastian Mircea on 17/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
///Users/so/Desktop/Projects/ArRobotCode/ArRobotCode/ViewController.swift
///Users/so/Desktop/Projects/ArRobotCode/ArRobotCode/Base.lproj/Main.storyboard
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Object detection
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Object Detection", bundle: Bundle.main)!
        print("Run Configuration")
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor {
            print("Detected ARObjectAnchor")
            
            // Create the plane
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x), height: CGFloat(objectAnchor.referenceObject.extent.y))
            plane.cornerRadius = plane.width / 8
            
            // Create the sprite kit scene object
            let spriteKitScene = SKScene(fileNamed: "Tile")
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = true
//            plane.firstMaterial?.diffuse.con= SCNVector4Make(0, 1, 0, Float(M_PI/2))
// SCNMatrix4Translate(SCNMatrix4MakeScale(1, , 1), 1, 0, 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.rotation =  SCNVector4Make(1, 0, 0, Float.pi/2)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x , objectAnchor.referenceObject.center.y - 0.1, objectAnchor.referenceObject.center.z)
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
