//
//  BluetoothManager.swift
//  macOSHostApp
//
//  Created by Nikos Mouchtaris on 9/6/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//

import CoreBluetooth

var singleton = BluetoothManager()
class BluetoothManager: NSObject {
    
    var peripherals:[CBPeripheral] = []
    override init(){
        
    }
    lazy var manager: CBCentralManager = {
        return CBCentralManager(delegate: self, queue: nil)
    }()
    func scanBLEDevice(){
        print("sdfgfds")
        manager = CBCentralManager(delegate: self, queue: nil)
        //        manager?.scanForPeripherals(withServices: nil, options: nil)
        
    }

}
extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            manager.scanForPeripherals(withServices: nil)
            
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!peripherals.contains(peripheral)){
            peripherals.append(peripheral)
            if(peripheral.name != nil){
                print(peripheral.name!)
            }
            
        }
        
    }
    
}
