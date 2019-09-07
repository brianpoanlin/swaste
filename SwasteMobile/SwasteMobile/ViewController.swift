//
//  ViewController.swift
//  SwasteMobile
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var socket: SocketCommunicator?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "http://ec2-54-221-167-75.compute-1.amazonaws.com:3000") else {
            return
        }
        
        socket = SocketCommunicator(url: url)
        socket?.delegate = self
        socket?.connect()
    }
}

extension ViewController: SocketCommunicatorDelegate {
    func didConnect() {
        print("Socket connected!")
    }
    
    func didReceiveData(data: [Any]) {
        print(data)
    }
    
}
