//
//  ObjectDetector.swift
//  SwasteMobile
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

protocol ObjectDetectorDelegate {
    func promptRecycle()
    func promptLandfill()
    func promptCompost()
}

class ObjectDetector: NSObject {
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    var delegate: ObjectDetectorDelegate?
    var cameraView: UIView!
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    var detectionOverlay: CALayer! = nil
    private var isPaused = false
    
    let compostHash: [String: Int] = [
        "apple"     :   1,
        "banana"    :   1,
    ]
    
    let recycleHash: [String: Int] = [
        "soda can"                  :   1,
        "Hunter's water bottles"    :   1,
        "glass"                     :   1
    ]
    
    let trashHash: [String: Int] = [
        "coffeecups"      :   1,
        "plasic bag"     :   1,
    ]
    
    // Vision parts
    var requests = [VNRequest]()
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func start() {
        setupAVCapture()
        setupLayers()
        updateLayerGeometry()
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
    
    func setupAVCapture() {
            var deviceInput: AVCaptureDeviceInput!
            
            // Select a video device, make an input
            let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first
            do {
                deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            } catch {
                print("Could not create video device input: \(error)")
                return
            }
            
            session.beginConfiguration()
            session.sessionPreset = .vga640x480 // Model image size is smaller.
            
            // Add a video input
            guard session.canAddInput(deviceInput) else {
                print("Could not add video device input to the session")
                session.commitConfiguration()
                return
            }
            session.addInput(deviceInput)
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
                // Add a video data output
                videoDataOutput.alwaysDiscardsLateVideoFrames = true
                videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
                videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            } else {
                print("Could not add video data output to the session")
                session.commitConfiguration()
                return
            }
            let captureConnection = videoDataOutput.connection(with: .video)
            // Always process the frames
            captureConnection?.isEnabled = true
            do {
                try  videoDevice!.lockForConfiguration()
                let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
                bufferSize.width = CGFloat(dimensions.width)
                bufferSize.height = CGFloat(dimensions.height)
                videoDevice!.unlockForConfiguration()
            } catch {
                print(error)
            }
            session.commitConfiguration()
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.connection?.videoOrientation = .landscapeRight
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            rootLayer = cameraView.layer
            previewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(previewLayer)
        }
        
        func startCaptureSession() {
            session.startRunning()
        }
        
        // Clean up capture setup
        func teardownAVCapture() {
            previewLayer.removeFromSuperlayer()
            previewLayer = nil
        }
        
        func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
                let curDeviceOrientation = UIDevice.current.orientation
                let exifOrientation: CGImagePropertyOrientation
                
                switch curDeviceOrientation {
                case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                    exifOrientation = .left
                case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                    exifOrientation = .upMirrored
                case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                    exifOrientation = .down
                case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                    exifOrientation = .up
                default:
                    exifOrientation = .up
                }
            
            return exifOrientation
        }
        
        
        
        @discardableResult
        func setupVision() -> NSError? {
            // Setup Vision parts
            let error: NSError! = nil
            
            
            guard let modelURL = Bundle.main.url(forResource: "ImageClassifier", withExtension: "mlmodelc") else {
                return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
            }
            do {
                let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
                let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                    DispatchQueue.main.async(execute: {
                        // perform all the UI updates on the main queue
                        if self.isPaused {
                            return
                        }
                        
                        if let results = request.results {
                            for observation in results {
                                guard let objectObservation = observation as? VNClassificationObservation else {
                                    continue
                                }
                                if(objectObservation.confidence > 0.45) {
                                    print(objectObservation.identifier)
                                    let id = objectObservation.identifier
                                    if let _ = self.recycleHash[id] {
                                        self.delegate?.promptRecycle()
                                    }
                                    
                                    if let _ = self.compostHash[id] {
                                        self.delegate?.promptCompost()
                                    }
                                    
                                    if let _ = self.trashHash[id] {
                                        self.delegate?.promptLandfill()
                                    }
                                             
//                                    if objectObservation.identifier == "soda can" || objectObservation.identifier == "Hunter's water bottles" {
//                                        self.delegate?.promptRecycle()
//                                    } else if objectObservation.identifier == "banana" {
//                                        self.delegate?.promptCompost()
//                                    } else if objectObservation.identifier == "trash" {
//                                        self.delegate?.promptLandfill()
//                                    }
                                }
                            }
                        }
                    })
                })
                self.requests = [objectRecognition]
            } catch let error as NSError {
                print("Model loading went wrong: \(error)")
            }
            
            return error
        }
        
        func getResultArray(_ results: [Any]) {
            
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            detectionOverlay.sublayers = nil // remove all the old recognized objects
            for observation in results {
                guard let objectObservation = observation as? VNClassificationObservation else {
                    continue
                }
                print("ok")
                print(objectObservation.identifier)
                print(objectObservation.confidence)
            }
            self.updateLayerGeometry()
            CATransaction.commit()
        }
        
        
        func setupLayers() {
            detectionOverlay = CALayer() // container layer that has all the renderings of the observations
            detectionOverlay.name = "DetectionOverlay"
            detectionOverlay.bounds = CGRect(x: 0.0,
                                             y: 0.0,
                                             width: bufferSize.width,
                                             height: bufferSize.height)
            detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
            rootLayer.addSublayer(detectionOverlay)
        }
        
        func updateLayerGeometry() {
            let bounds = rootLayer.bounds
            var scale: CGFloat
            
            let xScale: CGFloat = bounds.size.width / bufferSize.height
            let yScale: CGFloat = bounds.size.height / bufferSize.width
            
            scale = fmax(xScale, yScale)
            if scale.isInfinite {
                scale = 1.0
            }
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            // rotate the layer into screen orientation and scale and mirror
            detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
            // center the layer
            detectionOverlay.position = CGPoint (x: bounds.midX, y: bounds.midY)
            
            CATransaction.commit()
            
        }
}

extension ObjectDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            let exifOrientation = exifOrientationFromDeviceOrientation()
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
            do {
                try imageRequestHandler.perform(self.requests)
            } catch {
                print(error)
            }
        // to be implemented in the subclass
    }
}
