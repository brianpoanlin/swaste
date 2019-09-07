//
//  ViewController.swift
//  SwasteMac
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var socket: SocketCommunicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "http://localhost:8080") else {
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
