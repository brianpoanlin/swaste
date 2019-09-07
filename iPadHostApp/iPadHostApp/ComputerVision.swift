//
//  ComputerVision.swift
//  iPadHostApp
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 Nikos Mouchtaris. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ComputerVision: NSObject {
    private let visionQueue = DispatchQueue(label: "com.example.apple-samplecode.FlowerShop.serialVisionQueue")
    private var analysisRequests = [VNRequest]()
    private let sequenceRequestHandler = VNSequenceRequestHandler()

    override init(){
        super.init()
        guard let modelURL = Bundle.main.url(forResource: "ImageClassifier", withExtension: "mlmodelc") else {
            return
        }
        guard let objectRecognition = createClassificationRequest(modelURL: modelURL) else {
            return
        }
        analysisRequests.append(objectRecognition)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        
//        let registrationRequest = VNTranslationalImageRegistrationRequest(targetedCVPixelBuffer: pixelBuffer)
//        do {
//            try sequenceRequestHandler.perform([ registrationRequest ], on: pixelBuffer!)
//        } catch let error as NSError {
//            print("Failed to process request: \(error.localizedDescription).")
//            return
//        }
//        
//        
//        if let results = registrationRequest.results {
//            if let alignmentObservation = results.first as? VNImageTranslationAlignmentObservation {
//                let alignmentTransform = alignmentObservation.alignmentTransform
//                self.recordTransposition(CGPoint(x: alignmentTransform.tx, y: alignmentTransform.ty))
//            }
//        }
        analyzeCurrentImage(currentlyAnalyzedPixelBuffer: pixelBuffer)
    }
    
    private func createClassificationRequest(modelURL: URL) -> VNCoreMLRequest? {
        do {
            let objectClassifier = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let classificationRequest = VNCoreMLRequest(model: objectClassifier, completionHandler: { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    print("\(results.first!.identifier) : \(results.first!.confidence)")
                    if results.first!.confidence > 0.9 {
                        print("good")
                    }
                }
            })
            return classificationRequest
            
        } catch let error as NSError {
            print("Model failed to load: \(error).")
            return nil
        }
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, Home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, Home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, Home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, Home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    private func analyzeCurrentImage(currentlyAnalyzedPixelBuffer: CVPixelBuffer?) {
        // Most computer vision tasks are not rotation-agnostic, so it is important to pass in the orientation of the image with respect to device.
        let orientation = exifOrientationFromDeviceOrientation()
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentlyAnalyzedPixelBuffer!, orientation: orientation)
        visionQueue.async {
            do {
                // Release the pixel buffer when done, allowing the next buffer to be processed.
                try requestHandler.perform(self.analysisRequests)
            } catch {
                print("Error: Vision request failed with error \"\(error)\"")
            }
        }
    }

}
