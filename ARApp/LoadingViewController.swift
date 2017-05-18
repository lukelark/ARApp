//
//  LoadingViewController.swift
//  ARApp
//
//  Created by Victor Krusenstråhle on 2017-05-18.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var animatedView: IdentifyView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedView.addSearchAnimation()
        backgroundView.layer.cornerRadius = 3
    }
    
}
