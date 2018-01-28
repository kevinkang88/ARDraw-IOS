//
//  ViewController.swift
//  Drawing
//
//  Created by kevin on 1/26/18.
//  Copyright © 2018 yooniverse. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.run(configuration)
        sceneView.showsStatistics = true 
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func draw(_ sender: Any) {
        
    }
    
    //ARSCNView delegate methods
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("rendering")

        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        // orientation: where your phone is facing
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        // location: placement of your phone relative to real world
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        
        let currentPositionOfCamera = orientation + location
        print(orientation.x, orientation.y, orientation.z)
        DispatchQueue.main.async {
            if(self.drawButton.isHighlighted){
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.05))
                sphereNode.position = currentPositionOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })
                
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentPositionOfCamera
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
