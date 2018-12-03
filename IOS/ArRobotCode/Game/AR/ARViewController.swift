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
import RxSwift

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var level : DataLevel?
    public var sceneController = GameScene()
    
    private var didInitializeScene: Bool = false
    private var planes = [ARPlaneAnchor: Plane]()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private var findingStartPosition: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = true
        
        // Assign the scene
        if let scene = sceneController.scene {
            // Set the scene to the view
            sceneView.scene = scene
        }
        
        // Set tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapScreen))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Object & plane detection
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Object Detection", bundle: Bundle.main)!
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    // Object detection callback
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
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.rotation =  SCNVector4Make(1, 0, 0, Float.pi/2)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x , objectAnchor.referenceObject.center.y - 0.1, objectAnchor.referenceObject.center.z)
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    // Add plane callback
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if(findingStartPosition == false) {
            return;
        }
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.addPlane(node: node, anchor: planeAnchor)
                self.feedbackGenerator.impactOccurred()
                return
            }
        }
    }
    
    // Update plane callback
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
            }
        }
    }
    
    // Remove plane callback
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    // Did Tap screen
    @objc func didTapScreen(recognizer: UITapGestureRecognizer) {
        if self.findingStartPosition == false {
            self.sceneController.playerController.moveFront()
        }
        
        if (sceneView.session.currentFrame?.camera) != nil && findingStartPosition == true {
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation)
            if let node = hitTestResults.first?.node {
                if let plane = node.parent as? Plane, let _ = plane.parent, let hitResult = hitTestResults.first {
                    _ = SCNVector3Make(
                        hitResult.worldCoordinates.x,
                        hitResult.worldCoordinates.y,
                        hitResult.worldCoordinates.z
                    )
                    
                    
                    
                    print("Plane width: ", plane.planeGeometry.width, ", height: ", plane.planeGeometry.height)
//                    plane.planeGeometr
    
                    // Create an anchor at that position
                    let anchor = ARAnchor(name: "gameCenter", transform: simd_float4x4(hitResult.modelTransform))
                    sceneView.session.add(anchor: anchor)
                    
                    // Move the player to the touch point
                    sceneController.setGamePosition(pos: hitResult.worldCoordinates, planeAnchor: plane.planeAnchor)
                    
                    // Spwan the level
                    sceneController.spawnLevel(level: self.level!)
                    
                    // Found the start position
                    findingStartPosition = false;
                    
                    // Remove the planes from the scene
                    self.removeAllPlanes()
                }
            }
        }
    }
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        planes[anchor] = plane
        plane.setPlaneVisibility(true)
        
        node.addChildNode(plane)
        print("Added plane: \(plane)")
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    func removeAllPlanes() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "plane" {
                //edit something
                node.removeFromParentNode()
            }
        }
    }
    
    func removePlane(anchor: ARPlaneAnchor) {
        if let plane = planes.removeValue(forKey: anchor) {
            plane.removeFromParentNode()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
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
