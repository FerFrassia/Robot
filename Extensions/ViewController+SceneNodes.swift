//
//  ViewController+SceneNodes.swift
//  Robot
//
//  Created by Fernando N. Frassia on 7/11/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import SceneKit
import ARKit


extension ViewController {
    
    func addRobotTo(node: SCNNode) {
        guard let robotScene = SCNScene(named: "Models.scnassets/toy_robot_vintage.scn") else {return}
        let robotNode = robotScene.rootNode.childNodes.first!
        node.addChildNode(robotNode)
    }
    
}
