//
//  ViewController.swift
//  ServoControlHost
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var serialPort: ORSSerialPort?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serialPort = ORSSerialPort(path: "/dev/tty.usbmodem14501")
        serialPort?.baudRate = 9600
        serialPort?.delegate = self
        serialPort?.open()
        print("SETUP")
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func move1(_ sender: Any) {
        sendString("1\n")
    }
    
    @IBAction func move2(_ sender: Any) {
        sendString("2\n")
    }
    
    @IBAction func move3(_ sender: Any) {
        sendString("3\n")
    }
    @IBAction func reset1(_ sender: Any) {
        sendString("4\n")
    }
    
    @IBAction func reset2(_ sender: Any) {
        sendString("5\n")
    }
    
    @IBAction func reset3(_ sender: Any) {
        sendString("6\n")
    }
    
    func sendString(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        
        serialPort?.send(data)
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

