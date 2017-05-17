//
//  tableViewCell.swift
//  ARApp
//
//  Created by Daniel Krusenstrahle on 17/05/2017.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UILabel!
    
    override func layoutSubviews()  {
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    internal func configure(title: String?, symbol: String?) {
        label!.text = title
        icon!.text = symbol
    }
    
}
