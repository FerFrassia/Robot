//
//  ViewController.swift
//  Robot
//
//  Created by Fernando N. Frassia on 6/27/19.
//  Copyright © 2019 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: VirtualObjectARView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var trackingBtn: UIButton!
    
    var robot: VirtualObject?
    var configurationIsTrackingImages = false
    var currentAngleY: Float = 0
    
    //MARK: - ARKit Variables
    let coachingOverlay = ARCoachingOverlayView()
    var focusSquare = FocusSquare()
    let virtualObjectLoader = VirtualObjectLoader()
    
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        setupCoachingOverlay()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPlanes()
    }
    
    @IBAction func trackingBtnPressed(_ sender: Any) {
        changeTracking()
    }
    
    @IBAction func addObjectBtnPressed(_ sender: Any) {
        placeRobot()
    }
    
}

