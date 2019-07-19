//
//  ViewController+Gestures.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/11/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SceneKit


extension ViewController {
    func addGestures() {
//        addTapGesture()
    }
    
//MARK: - Panthreshold
    func addThresholdPanGesture() {
        let thresholdPanGesture = ThresholdPanGesture(target: self, action: #selector(didThresholdPan(_:)))
        sceneView.addGestureRecognizer(thresholdPanGesture)
    }
    
    @objc func didThresholdPan(_ gesture: ThresholdPanGesture) {
    }
    
//MARK: - Tap
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        if robot == nil || configurationIsTrackingImages {return}
        
    }
    
//MARK: - Pinch
    func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if robot == nil || configurationIsTrackingImages {return}
        
        var originalScale = robot?.scale
        let defaultScale = CGFloat(0.005)
        let minScale = defaultScale/2
        let maxScale = defaultScale*2
        
        switch gesture.state {
        case .began:
            originalScale = robot?.scale
            gesture.scale = CGFloat((robot?.scale.x)!)
        case .changed:
            guard var newScale = originalScale else {return}
            if gesture.scale < minScale {
                newScale = SCNVector3(x: Float(minScale), y: Float(minScale), z: Float(minScale))
            } else if gesture.scale > maxScale {
                newScale = SCNVector3(x: Float(maxScale), y: Float(maxScale), z: Float(maxScale))
            } else {
                newScale = SCNVector3(x: Float(gesture.scale), y: Float(gesture.scale), z: Float(gesture.scale))
            }
            robot?.scale = newScale
        case .ended:
            return
        default:
            return
        }
    }
    
//MARK: - Pan
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        sceneView.addGestureRecognizer(panGesture)
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        if robot == nil || configurationIsTrackingImages {return}
        
        let translation = gesture.translation(in: sceneView)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY
        robot?.eulerAngles.y = newAngleY
        
        if gesture.state == .ended {
            currentAngleY = newAngleY
        }
        
    }
}
