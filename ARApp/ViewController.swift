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
import FirebaseStorage

@objc protocol ViewControllerDelegate {
    @objc optional func dismiss()
}

class ViewController: ARCameraViewController {

    var delegate: ViewControllerDelegate?

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var animationView: IdentifyView!
    
    @IBOutlet weak var scanAgainButton: UIButton!
    
    var UID: String = String()
    var userArray: [String] = []
    let defaultImageSize = 600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanAgainButton.isHidden = true
        loadingView.isHidden = false
        loadingView.layer.cornerRadius = 5
        animationView.addSearchAnimation()
    }
    
    // MARK : - AR
    override func setupContent() {
        self.load(completion: { (string) -> () in
            let string = string
            let image = self.generateQRCode(string: string)
            
            let imageTrackable = ARImageTrackable(image: image, name: "")
            
            let trackerManager = ARImageTrackerManager.getInstance()
                trackerManager?.initialise()
                trackerManager?.addTrackable(imageTrackable)
            
            self.grabImage(completion: { (Image) -> () in
                print("IMAGE RETURNED")
                let imageNode = ARImageNode(image: Image)
                imageTrackable?.world.addChild(imageNode)
                self.loadingView.isHidden = true
                self.scanAgainButton.isHidden = false
            })
        })
    }
    
    func load(completion: @escaping (String) -> ()) {
        print("GRABBING UID")
        completion(UID)
    }
    
    func grabImage(completion: @escaping (UIImage) -> ()) {
        print("GRABBING IMAGE")
        
        let reference = FIRStorage.storage().reference(withPath: "\(UID).jpg")
            reference.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                self.animationView.addVerifiedAnimation()
                self.loadingLabel.text = "Verifierad"
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    let image = UIImage(data: data!)
                    completion(image!)
                }
            }
        }
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
        delegate?.dismiss!()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func scanAgain(_ sender: Any) {
        delegate?.dismiss!()
        dismiss(animated: true, completion: nil)
    }
    
}

