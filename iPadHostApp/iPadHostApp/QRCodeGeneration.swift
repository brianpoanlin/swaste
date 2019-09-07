//
//  QRCodeGeneration.swift
//  iPadHostApp
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//

import UIKit

class QRCodeGeneration: NSObject {
    
    func getQRCode()->UIImage?{
        
        let myString = "https://pennlabs.org"
        // Get data from the string
        let data = myString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil}
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        return processedImage
    }

}
