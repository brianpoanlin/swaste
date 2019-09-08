//
//  TrashDataTableViewCell.swift
//  QRScanner
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit

class TrashDataTableViewCell: UITableViewCell {

    @IBOutlet weak var recyclingPicture: UIImageView!
    @IBOutlet weak var recyclingNumber: UILabel!
    
    @IBOutlet weak var trashPicture: UIImageView!
    @IBOutlet weak var trashNumber: UILabel!
    
    @IBOutlet weak var compostPicture: UIImageView!
    @IBOutlet weak var compostNumber: UILabel!
    
    @IBOutlet weak var pointsForTransaction: UILabel!
    @IBOutlet weak var timeLength: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recyclingPicture.image = UIImage(named: "recycle")
        trashPicture.image = UIImage(named: "trash_bin")
        compostPicture.image = UIImage(named: "compost")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
