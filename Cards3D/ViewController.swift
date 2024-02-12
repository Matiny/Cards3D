//
//  ViewController.swift
//  Cards3D
//
//  Created by Matiny Software on 2/11/24.
//

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration to track images in the real world
        let configuration = ARImageTrackingConfiguration()
        
        // Locate our images
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 1
            
        }
        
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    // Using an anchor (image), return a node (3d object)
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        // Check if real world image is an anchor
        if let imageAnchor = anchor as? ARImageAnchor {
            // Set the plane size
            let planeSize = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            planeSize.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            // The 3d object
            let planeNode = SCNNode(geometry: planeSize)
            
            // 90° counterclockwise on x axis
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn") {
                print("Scene Added!")
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    planeNode.addChildNode(pokeNode)
                    print("Model Added!")
                }
            }
        }
        
        
        return node
    }
}
