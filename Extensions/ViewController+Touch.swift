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

enum ConfigurationType {
    case trackingImages
    case trackingPlanes
}

extension ViewController {
    
    func changeTracking() {
        configurationIsTrackingImages = !configurationIsTrackingImages
        if configurationIsTrackingImages {
            startTracking(type: .trackingImages)
        } else {
            startTracking(type: .trackingPlanes)
        }
    }
    
    func startTracking(type: ConfigurationType) {
        if type == .trackingPlanes {
            trackPlanes()
        } else {
            trackImages()
        }
        
        let trackingBtnTitle = type == .trackingImages ? "Image Tracking" : "Plane Tracking"
        trackingBtn.setTitle(trackingBtnTitle, for: .normal)
        addObjectButton.isHidden = type == .trackingImages
        coachingOverlay.setActive(type == .trackingPlanes, animated: false)
        coachingOverlay.activatesAutomatically = type == .trackingPlanes
        focusSquare.isHidden = type == .trackingImages
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
