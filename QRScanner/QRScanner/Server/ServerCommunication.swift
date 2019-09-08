//
//  ServerCommunication.swift
//  QRScanner
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit
protocol serverCommDelegate {
    func gotData(data: SwasteData);
}
class ServerCommunication: NSObject {
    override init(){
        
    }
    
    func getSwasteUserData(delegate: serverCommDelegate){
        
        guard let eventDataURL = URL(string: "https://qka9ihfsrh.execute-api.us-east-1.amazonaws.com/beta/get-user-data") else {
            print("Error")
            exit(2)
        }
        let eventDataFetcher = NetworkCommunication(url: eventDataURL)
        eventDataFetcher.getData(parameters: ["sub" : "nikos"]) { (data) in
            guard let data = data else {
                return
            }
            let convertedString = String(data: data, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString) // <-- here is ur string
            
            let rawEventsDecoder = JSONDecoder()
            guard let swastData = try? rawEventsDecoder.decode(SwasteData.self, from: data) else {
                return
            }
            DispatchQueue.main.async {
                delegate.gotData(data: swastData)
            }
        }
//        var ok = SwasteData(json : "")
        return
    }

}
