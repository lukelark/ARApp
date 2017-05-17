//
//  QRReaderViewController.swift
//  qarder
//
//  Created by Daniel Krusenstrahle on 05/02/2017.
//  Copyright © 2017 Daniel Krusenstrahle. All rights reserved.
//

import UIKit
import AVFoundation
import Spring
import AudioToolbox
import KudanAR
import QRCode
import FirebaseDatabase
import FirebaseAuth

@objc protocol QRReaderViewControllerDelegate {
    @objc optional func codeDidRead(code:String)
}

class QRReaderViewController: ARCameraViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: QRReaderViewControllerDelegate?
    var userArray: [String] = []
    let defaultImageSize = 600
    var UID: String = String()
    var runContent = false
    
    private var overlay: CAShapeLayer = {
        var overlay             = CAShapeLayer()
        overlay.backgroundColor = UIColor.clear.cgColor
        overlay.fillColor       = UIColor.clear.cgColor
        overlay.strokeColor     = UIColor.white.cgColor
        overlay.lineWidth       = 3
        overlay.lineDashPattern = [7.0, 7.0]
        overlay.lineDashPhase   = 0
        
        return overlay
    }()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var containerView: SpringView!
    @IBOutlet weak var viewFinder: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoView: SpringView!
    @IBOutlet weak var lightToggle: UIButton!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleFlash()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        viewFinder.layer.borderWidth = 5.0
        viewFinder.layer.borderColor = UIColor.white.cgColor
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
            view.bringSubview(toFront: containerView)
            view.bringSubview(toFront: infoView)
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
    }
    
    // MARK : - AR
    override func setupContent() {
        if(runContent) {
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
    
    // MARK : - Essentials
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func setupShadow(UIItem: AnyObject, offsetX: CGFloat, offsetY: CGFloat, spread: CGFloat, alpha: Float, HEXColor: String) {
        UIItem.layer.shadowColor = hexStringToUIColor(hex: HEXColor).cgColor
        UIItem.layer.shadowOpacity = alpha
        UIItem.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        UIItem.layer.shadowRadius = spread
    }
    
    @IBAction func toggleFlashlightAction(_ sender: Any) {
        toggleFlash()
    }
    
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureTorchMode.on) {
                    device?.torchMode = AVCaptureTorchMode.off
                    setupShadow(UIItem: lightToggle, offsetX: 0, offsetY: 0, spread: 5, alpha: 0.0, HEXColor: "FFFFFF")
                    lightToggle.setTitleColor(hexStringToUIColor(hex: "FFFFFF"), for: .normal)
                } else {
                    do {
                        try device?.setTorchModeOnWithLevel(1.0)
                        setupShadow(UIItem: lightToggle, offsetX: 0, offsetY: 0, spread: 15, alpha: 1.0, HEXColor: "00c7c7")
                        lightToggle.setTitleColor(hexStringToUIColor(hex: "85edd2"), for: .normal)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        containerView.isHidden = false
        containerView.damping = 1
        containerView.animation = "fadeIn"
        containerView.animate()
        infoView.isHidden = false
        infoView.y = -100
        infoView.damping = 1
        infoView.animation = "slideUp"
        infoView.animate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedBarCodes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                delegate?.codeDidRead!(code: metadataObj.stringValue)
                
                runContent = true
                UID = metadataObj.stringValue
                print("FUNKAR QR READER")
                setupContent()
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                let systemSoundID: SystemSoundID = 1114
                AudioServicesPlaySystemSound (systemSoundID)
            }
        }
    }
}
