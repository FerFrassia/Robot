//
//  ViewController+SceneView.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/15/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import SceneKit

extension ViewController {
    
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.setupDirectionalLighting(queue: updateQueue)
    }
    
}
