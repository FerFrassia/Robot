//
//  ViewController+VirtualObjectSelection.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/16/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import FFTopNotification

extension ViewController {
    
    func placeRobot() {
        guard !addObjectButton.isHidden && !virtualObjectLoader.isLoading else {return}
        
        guard let robotObject = VirtualObject.availableObjects.first else {return}
        activityIndicator.startAnimating()
        
        virtualObjectLoader.loadVirtualObject(robotObject) { (loadedObject) in
            do {
                let scene = try SCNScene(url: robotObject.referenceURL, options: nil)
                self.sceneView.prepare([scene], completionHandler: { _ in
                    DispatchQueue.main.async {
                        self.hideObjectLoadingUI()
                        self.placeVirtualObject(loadedObject)
                        loadedObject.isHidden = false
                        self.activityIndicator.stopAnimating()
                        self.addObjectButton.isHidden = true
                        self.robot = loadedObject
                    }
                })
            } catch {
                fatalError("Failed to load SCNScene from object.referenceURL")
            }
        }
    }
    
    func placeVirtualObject(_ virtualObject: VirtualObject) {
        guard focusSquare.state != .initializing,
            let query = sceneView.raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: virtualObject.allowedAlignment) else {return}
        
        virtualObject.raycast = getTrackedRaycast(query, virtualObject: virtualObject)
    }
    
    func getTrackedRaycast(_ query: ARRaycastQuery, virtualObject: VirtualObject) -> ARTrackedRaycast? {
        return sceneView.session.trackedRaycast(query) { (results) in
            self.setVirtualObject3DPosition(results, with: virtualObject)
        }
    }
    
    func setVirtualObject3DPosition(_ results: [ARRaycastResult], with virtualObject: VirtualObject) {
        guard let result = results.first else {
            view.displayNotification(text: "Object out of plane", type: .failure)
            return
        }
        
        virtualObject.simdWorldTransform = result.worldTransform
        
        // If the virtual object is not yet in the scene, add it.
        if virtualObject.parent == nil {
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
            virtualObject.shouldUpdateAnchor = true
        }
        
        if virtualObject.shouldUpdateAnchor {
            virtualObject.shouldUpdateAnchor = false
            updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: virtualObject)
                self.virtualObjectInteraction.selectedObject = virtualObject
            }
        }
    }
    
    func createRaycastAndUpdate3DPosition(of virtualObject: VirtualObject, from query: ARRaycastQuery) {
        guard let result = sceneView.session.raycast(query).first else {
            return
        }
        
        if virtualObject.allowedAlignment == .any && self.virtualObjectInteraction.trackedObject == virtualObject {
            
            // If an object that's aligned to a surface is being dragged, then
            // smoothen its orientation to avoid visible jumps, and apply only the translation directly.
            virtualObject.simdWorldPosition = result.worldTransform.translation
            
            let previousOrientation = virtualObject.simdWorldTransform.orientation
            let currentOrientation = result.worldTransform.orientation
            virtualObject.simdWorldOrientation = simd_slerp(previousOrientation, currentOrientation, 0.1)
        } else {
            self.setTransform(of: virtualObject, with: result)
        }
    }
    
    func setTransform(of virtualObject: VirtualObject, with result: ARRaycastResult) {
        virtualObject.simdWorldTransform = result.worldTransform
        if virtualObject.lastKnownScale != nil {
            virtualObject.scale = virtualObject.lastKnownScale!
        }
    }

    
    // MARK: Object Loading UI
    func displayObjectLoadingUI() {
        addObjectButton.setImage(#imageLiteral(resourceName: "ButtonRing"), for: [])
        addObjectButton.isEnabled = false
    }
    
    func hideObjectLoadingUI() {
        addObjectButton.setImage(#imageLiteral(resourceName: "Add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "AddPressed"), for: [.highlighted])
        addObjectButton.isEnabled = true
    }
}
