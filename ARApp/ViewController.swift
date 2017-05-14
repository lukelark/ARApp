//
//  ViewController.swift
//  ARApp
//
//  Created by Victor Krusenstråhle on 2017-05-14.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import KudanAR
import QRCode

class ViewController: ARCameraViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupContent() {
        
        let string = "Victor Krusenstrahle" // UID GOES HERE
        let image = generateQRCode(string: string)
        
        // Initialise image trackable
        let imageTrackable = ARImageTrackable(image: image, name: "")
        
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
    
    func generateQRCode(string: String) -> UIImage {
        var qrCode = QRCode(string)
            qrCode?.size = CGSize(width: 600, height: 600)
        
        return (qrCode?.image)!
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

