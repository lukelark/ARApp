//
//  ViewController.swift
//  ARApp
//
//  Created by Victor Krusenstråhle on 2017-05-14.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import KudanAR

class ViewController: ARCameraViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupContent() {
        
        // Initialise image trackable
        let imageTrackable = ARImageTrackable(image: UIImage(named: "qrcode.jpg"), name: "qrcode")
        
        // Get instance of image tracker manager
        let trackerManager = ARImageTrackerManager.getInstance()
        trackerManager?.initialise()
        
        // Add image trackable to image tracker manager
        trackerManager?.addTrackable(imageTrackable)
        
        // Initialise image node
        let imageNode = ARImageNode(bundledFile: "victor.jpg")
        
        // Add image node to image trackable
        imageTrackable?.world.addChild(imageNode)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

