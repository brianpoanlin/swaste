//
//  ClassifierResultViewController.swift
//  iPadHostApp
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//

import UIKit

class ClassifierResultViewController: UIViewController {

    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:  #selector(self.objectFound), userInfo: nil, repeats: true)
        var cv = ComputerVision()
    }
    
    @objc func objectFound(){
        performSegue(withIdentifier: "ShowNearbyDevices", sender: self)
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
