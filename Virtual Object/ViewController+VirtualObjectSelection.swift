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

extension ViewController {
    
    func placeRobot() {
        guard !addObjectButton.isHidden && !virtualObjectLoader.isLoading else {return}
        
        guard let robotObject = VirtualObject.availableObjects.first else {return}
        virtualObjectLoader.loadVirtualObject(robotObject) { (loadedObject) in
            do {
                let scene = try SCNScene(url: robotObject.referenceURL, options: nil)
                self.sceneView.prepare([scene], completionHandler: { _ in
                    DispatchQueue.main.async {
                        self.hideObjectLoadingUI()
                        self.placeVirtualObject(loadedObject)
                        loadedObject.isHidden = false
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
            fatalError("Unexpected case: the update handler is always supposed to return at least one result.")
        }
        
        virtualObject.simdWorldTransform = result.worldTransform
        
        // If the virtual object is not yet in the scene, add it.
        if virtualObject.parent == nil {
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
            virtualObject.shouldUpdateAnchor = true
        }
        
        if virtualObject.shouldUpdateAnchor {
            virtualObject.shouldUpdateAnchor = false
            DispatchQueue.main.async {
                self.sceneView.addOrUpdateAnchor(for: virtualObject)
            }
        }
    }
    
    // MARK: Object Loading UI
    func displayObjectLoadingUI() {
        addObjectButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
        addObjectButton.isEnabled = false
    }
    
    func hideObjectLoadingUI() {
        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
        addObjectButton.isEnabled = true
    }
}
