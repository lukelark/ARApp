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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func setupContent() {
        
        // Initialise image trackable
        let imageTrackable = ARImageTrackable(image: UIImage(named: "spaceMarker.jpg"), name: "space")
        
        // Get instance of image tracker manager
        let trackerManager = ARImageTrackerManager.getInstance()
        trackerManager?.initialise()
        
        // Add image trackable to image tracker manager
        trackerManager?.addTrackable(imageTrackable)
        
        // Initialise image node
        let imageNode = ARImageNode(bundledFile: "eyebrow.png")
        
        // Add image node to image trackable
        imageTrackable?.world.addChild(imageNode)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

