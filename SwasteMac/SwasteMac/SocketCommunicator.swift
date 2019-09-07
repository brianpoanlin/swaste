//
//  SocketCommunicator.swift
//  SwasteMac
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import Cocoa
import SocketIO

class SocketCommunicator: NSObject {
    
    let manager: SocketManager
    let client: SocketIOClient

    init(url: URL) {
        manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
        client = manager.defaultSocket
    }
    
    func connect() {
        client.on(clientEvent: .connect) {data, ack in
            print("socket connected!")
        }
        
        client.connect()
        addHandlers()
    }
    
    private func addHandlers() {
        client.on("didUpdate") {[weak self] data, ack in
            print(data)
        }
    }
    
    func sendData(value: Int) {
        client.emit("value", value)
    }
}
