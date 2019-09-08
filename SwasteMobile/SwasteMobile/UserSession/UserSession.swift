//
//  UserSession.swift
//  SwasteMobile
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import UIKit

enum DisposalActions: String {
    case Compost = "compost"
    case Trash = "trash"
    case Recycle = "recycle"
}

class UserSession: NSObject {
    private var actions = [DisposalActions]()
    
    func addDisposalAction(action: DisposalActions) {
        actions.append(action)
    }
    
    func upload(withUserID: String) {
        guard let dataURL = URL(string: "https://qka9ihfsrh.execute-api.us-east-1.amazonaws.com/beta/post-disposal-data") else {
            print("Error")
            return
        }

        var stringArray = [String]()
        
        for entry in actions {
            stringArray.append(entry.rawValue)
        }
        
        let compiledData: [String: Any] = ["actionArray"   :   stringArray,
                                           "deviceId"   :   withUserID]
        
        let sessionsUpload = NetworkCommunication(url: dataURL)
        sessionsUpload.sendData(jsonData: compiledData) { (data) in
            print(String(data: data!, encoding: .utf8))
        }
        
    }
}
