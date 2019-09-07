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
    var serialPort: ORSSerialPort?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://www.swaste.tech") else {
            return
        }
        
        socket = SocketCommunicator(url: url)
        socket?.delegate = self
        socket?.connect()
        
        serialPort = ORSSerialPort(path: "/dev/cu.usbmodem14601")
        serialPort?.baudRate = 9600
        serialPort?.delegate = self
        serialPort?.open()
    }
    
    func sendString(_ string: String) {
        guard let data = (string + "\n").data(using: .utf8) else {
            return
        }
        
        serialPort?.send(data)
    }
}

extension ViewController: SocketCommunicatorDelegate {
    func didConnect() {
        print("Socket connected!")
    }
    
    func didReceiveData(data: [Any]) {
        guard let input = data[0] as? Int else {
            return
        }
        
        print(input)
        sendString(String(input))
    }
    
}

extension ViewController: ORSSerialPortDelegate {
    private func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        if let string = String(data: data as Data, encoding: .utf8) {
            print("\(string)")
        }
    }

    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }

    private func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }

    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
    
}
