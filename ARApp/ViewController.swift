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
import FirebaseDatabase
import FirebaseAuth

@objc protocol ViewControllerDelegate {
    @objc optional func dismiss()
}

class ViewController: ARCameraViewController {

    var delegate: ViewControllerDelegate?

    var UID: String = String()
    var userArray: [String] = []
    let defaultImageSize = 600
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK : - AR
    override func setupContent() {
        print("FUNKAR : SETUPCONTENT")
        let string = UID // Should be provided by QR reader.
        let image = generateQRCode(string: string)
            
        // Initialise image trackable
        let imageTrackable = ARImageTrackable(image: image, name: "")
            
        // Get instance of image tracker manager
        let trackerManager = ARImageTrackerManager.getInstance()
        trackerManager?.initialise()
            
        // Add image trackable to image tracker manager
        trackerManager?.addTrackable(imageTrackable)
            
        // IMAGE
        // Initialise image node
        let imageNode = ARImageNode(bundledFile: "victor.jpg") // Should be provided by firebase
            
        // Add image node to image trackable
        imageTrackable?.world.addChild(imageNode)
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
    
    func grabData() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child("staff").observe(.childAdded, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let UID = value?["uid"] as? String
            let name = value?["name"] as? String
            
            let key = "\(UID!)-\(name!)"
            
            self.userArray.append(key)
        })
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        delegate?.dismiss!()
    }


}

