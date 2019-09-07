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
        guard let url = URL(string: "https://www.swaste.tech") else {
            return
        }
        
        socket = SocketCommunicator(url: url)
        socket?.delegate = self
        socket?.connect()
    }
    
    @IBAction func send1(_ sender: Any) {
        socket?.sendData(value: 1)
    }
    
    @IBAction func send2(_ sender: Any) {
        socket?.sendData(value: 2)
    }
    
    @IBAction func send3(_ sender: Any) {
        socket?.sendData(value: 3)
    }
    @IBAction func reset1(_ sender: Any) {
        socket?.sendData(value: 4)
    }
    
    @IBAction func reset2(_ sender: Any) {
        socket?.sendData(value: 5)
    }
    @IBAction func reset3(_ sender: Any) {
        socket?.sendData(value: 6)
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
