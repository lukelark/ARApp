//
//  MainViewController.swift
//  ARApp
//
//  Created by Victor Krusenstråhle on 2017-05-14.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import QRCode

class MainViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var staffButton: UIButton!
    @IBOutlet weak var patientsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func patientsButton(_ sender: Any) {
        let ctrl = self.storyboard!.instantiateViewController(withIdentifier: "PatientsViewControllerId") as! PatientsViewController
        let navController = UINavigationController(rootViewController: ctrl)
        present(navController, animated:true, completion: nil)
    }
    
    @IBAction func staffButton(_ sender: Any) {
        let ctrl = self.storyboard!.instantiateViewController(withIdentifier: "StaffViewControllerId") as! StaffViewController
        let navController = UINavigationController(rootViewController: ctrl)
        present(navController, animated:true, completion: nil)
    }
    
    @IBAction func scanAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "QRReaderViewControllerId") as! QRReaderViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func addUser(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewUserViewControllerId") as! AddNewUserViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func showUsersAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowUsersViewControllerId") as! ShowUsersViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
