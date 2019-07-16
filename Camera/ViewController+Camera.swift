//
//  ViewController+Camera.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/16/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import Foundation

extension ViewController {
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
}
