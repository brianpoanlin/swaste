//
//  BluetoothDevicesTableViewCell.swift
//  iPadHostApp
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//

import UIKit

class BluetoothDevicesTableViewCell: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
