//
//  ViewController+Touch.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/11/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


extension ViewController {    
    func changeTracking() {
        if configurationIsTrackingImages {
            trackPlanes()
            trackingBtn.setTitle("Status: Plane Tracking", for: .normal)
        } else {
            trackImages()
            trackingBtn.setTitle("Status: Image Tracking", for: .normal)
        }
        configurationIsTrackingImages = !configurationIsTrackingImages
    }
    
    func trackPlanes() {
        let planeConfiguration = ARWorldTrackingConfiguration()
        planeConfiguration.planeDetection = .horizontal
        sceneView.session.run(planeConfiguration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.scene.rootNode.addChildNode(focusSquare)
    }
    
    func trackImages() {
        let configuration = ARWorldTrackingConfiguration()
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else {return}
        
        configuration.detectionImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}
