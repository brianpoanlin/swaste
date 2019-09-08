//
//  SocketCommunicator.swift
//  SwasteMac
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import SocketIO

protocol SocketCommunicatorDelegate {
    func didConnect()
    func didReceiveData(data: [Any])
}

class SocketCommunicator: NSObject {
    
    private let manager: SocketManager
    private let client: SocketIOClient
    
    var delegate: SocketCommunicatorDelegate?

    init(url: URL) {
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        client = manager.defaultSocket
    }
    
    func connect() {
        client.on(clientEvent: .connect) {[weak self] data, ack in
            self?.delegate?.didConnect()
        }
        
        client.connect()
        addHandlers()
    }
    
    private func addHandlers() {
        client.on("didUpdate") {[weak self] data, ack in
            self?.delegate?.didReceiveData(data: data)
        }
    }
    
    func sendData(value: String) {
        client.emit("qrScanned", value)
    }
}
