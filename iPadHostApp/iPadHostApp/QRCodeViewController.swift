//
//  QRCodeViewController.swift
//  iPadHostApp
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet weak var qrCodeShow: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var ok = QRCodeGeneration()
        qrCodeShow.image = ok.getQRCode()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
