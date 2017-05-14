//
//  AddNewUserViewController.swift
//  ARApp
//
//  Created by Victor Krusenstråhle on 2017-05-14.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase
import QRCode
import AVFoundation
import MobileCoreServices
import Photos
import MediaPlayer
import SwiftEventBus

class AddNewUserViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var captureImageButton: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    var imagePicker: UIImagePickerController!
    var player = AVPlayer()
    var selectedMediaType: String = String()
    var selectedMediaName: String = String()
    var selectedMediaPath: String = String()
    var fb_random_key = arc4random()
    var Image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let UID = FIRAuth.auth()?.currentUser?.uid
        let UID = "Victor Krusenstrahle"
        let _QR_CODE_IMAGE = generateQRCode(string: UID)
        qrImageView.image = UIImage(cgImage: _QR_CODE_IMAGE.cgImage!)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
    }
    
    func generateQRCode(string: String) -> UIImage {
        var qrCode = QRCode(string)
        qrCode?.size = CGSize(width: 600, height: 600)
        
        return (qrCode?.image)!
    }
    
    @IBAction func captureImageAction(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func publish(_ sender: Any) {
    }
    
}
