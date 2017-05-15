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

    let defaultImageSize = 600
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupContent() {
        
        let string = "Victor Krusenstrahle" // UID GOES HERE
        let image = generateQRCode(string: string)
        
        let visualImage = self.resizeImage(image: UIImage(named: "victor.jpg")!, targetSize: CGSize(width: defaultImageSize, height: defaultImageSize)) // Bundle this.
        
        // Initialise image trackable
        let imageTrackable = ARImageTrackable(image: image, name: "")
        
        // Get instance of image tracker manager
        let trackerManager = ARImageTrackerManager.getInstance()
        trackerManager?.initialise()
        
        // Add image trackable to image tracker manager
        trackerManager?.addTrackable(imageTrackable)
        
         // IMAGE
        // Initialise image node
        let imageNode = ARImageNode(bundledFile: "victor.jpg")
        
        // Add image node to image trackable
        imageTrackable?.world.addChild(imageNode)
        
        
        // VIDEO
        /*
        // Initialise video node
        let videoNode = ARVideoNode(bundledFile: "victor.mp4")
        
        // Add video node to image trackable
        imageTrackable?.world.addChild(videoNode)
        */

    }
    
    func generateQRCode(string: String) -> UIImage {
        var qrCode = QRCode(string)
            qrCode?.size = CGSize(width: defaultImageSize - 10, height: defaultImageSize - 10)
        
        return (qrCode?.image)!
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

