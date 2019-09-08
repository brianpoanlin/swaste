//
//  SwasteData.swift
//  QRScanner
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit
//
//enum disposalType : NSInteger{
//  case recycle, trash, compost
//};

struct disposalData: Codable{
    var actions : [String]
    var time : Int
};

struct SwasteData: Codable {
    var points : Int
    var disposalHistory : [disposalData]
//    init(json : Data){
//
//
//
//
//        self.points = 288
//        var data = disposalData(actions: [disposalType.recycle, disposalType.trash], time: 2888888)
//
//        self.disposalHistory = [data, data, data]
//
//    }
    

}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
