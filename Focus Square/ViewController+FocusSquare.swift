//
//  ViewController+FocusSquare.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/16/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import Foundation
import ARKit

extension ViewController {
    
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        performRayCasting()
    }
    
    func performRayCasting() {
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = sceneView.session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = getRaycastQuery(),
            let result = sceneView.session.raycast(query).first {

            DispatchQueue.main.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            
            if !coachingOverlay.isActive {
                addObjectButton.isHidden = false
            }

        } else {
            DispatchQueue.main.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            addObjectButton.isHidden = true
        }
    }
        
    func getRaycastQuery() -> ARRaycastQuery? {
        return sceneView.raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: .any)
    }
    
}
