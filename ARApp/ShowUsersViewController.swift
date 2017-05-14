//
//  ShowUsersViewController.swift
//  ARApp
//
//  Created by Victor Krusenstråhle on 2017-05-14.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import QRCode

class ShowUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["Victor Krusenstrahle"]
    let items = [["Victor Krusenstrahle"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let UID = sections[indexPath.row]
        let QRCODEIMAGE = generateQRCode(string: UID)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath as IndexPath) as! userCell
            cell.imgView.image = UIImage(cgImage: QRCODEIMAGE.cgImage!)
            cell.usersName.text = UID
        
        return cell
    }
    
    func generateQRCode(string: String) -> UIImage {
        var qrCode = QRCode(string)
        qrCode?.size = CGSize(width: 600, height: 600)
        
        return (qrCode?.image)!
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

class userCell: UITableViewCell {
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
