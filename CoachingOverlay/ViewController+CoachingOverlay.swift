//
//  ViewController+CoachingOverlay.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/15/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import Foundation
import ARKit

extension ViewController: ARCoachingOverlayViewDelegate {
    
    func setupCoachingOverlay() {
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = .horizontalPlane
        
        setupCoachingOverlayConstraints()
    }
    
    func setupCoachingOverlayConstraints() {
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    /// - Tag: StartOver
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
    }
    
}
