//
//  ViewController+ARSCNViewDelegate.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/11/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import SceneKit
import ARKit


extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            handleImage(node: node, imageAnchor)
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let isAnyObjectInView = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        DispatchQueue.main.async {
            self.updateFocusSquare(isObjectVisible: isAnyObjectInView)
        }
        
        updateDirectionalLightIntensity()
    }
    
    func handleImage(node: SCNNode, _ imageAnchor: ARImageAnchor) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addRobotTo(node: node)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func handlePlane(node: SCNNode, _ planeAnchor: ARPlaneAnchor) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.addRobotTo(node: node)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateDirectionalLightIntensity() {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            sceneView.updateDirectionalLighting(intensity: lightEstimate.ambientIntensity, queue: updateQueue)
        } else {
            sceneView.updateDirectionalLighting(intensity: 1000, queue: updateQueue)
        }
    }
    
    func restartExperience() {
        guard !virtualObjectLoader.isLoading else {return}
        
        virtualObjectLoader.removeAllVirtualObjects()
        addObjectButton.setImage(#imageLiteral(resourceName: "Add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "AddPressed"), for: [.highlighted])
        
        resetTracking()
    }
    
    func resetTracking() {
        virtualObjectInteraction.selectedObject = nil
        trackPlanes()
    }
    
}
