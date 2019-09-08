//
//  NetworkCommunication.swift
//  Brian_Lin_HubSpot_2019
//
//  Created by Brian Lin on 8/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import Foundation

class NetworkCommunication: NSObject {
    private var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData(parameters: [String : String]?, completion: @escaping (_ result: Data?) -> ()) {
        var request = URLRequest(url: url)
        request.addValue("brian", forHTTPHeaderField: "sub")
//        if let parameters = parameters,
//            let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
//            
//            request.httpBody = parametersData
//        }
        
        sendRequest(request: request, completion: completion)
    }
    
    func sendData(jsonData: [String: Any], completion: @escaping (_ result: Data?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let bodyData = try? JSONSerialization.data(withJSONObject: jsonData) {
            request.httpBody = bodyData
            try? bodyData.write(to: URL(fileURLWithPath: "./result.json"))
        }
        
        sendRequest(request: request, completion: completion)
    }
    
    private func sendRequest(request: URLRequest, completion: @escaping (_ result: Data?) -> ()) {
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil,
                let response = response as? HTTPURLResponse
                else {
                    print("error")
                    completion(nil)
                    return
             }
            
            print("HTTP Response: \(response.statusCode)")
            
            completion(data)
        }
        
        task.resume()
    }
}
