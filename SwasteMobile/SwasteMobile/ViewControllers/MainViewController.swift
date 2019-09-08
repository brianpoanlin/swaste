//
//  ViewController.swift
//  SwasteMobile
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var socket: SocketCommunicator?
    let objectDetector = ObjectDetector()
    
    var recycleCard: InfoCard!
    var compostCard: InfoCard!
    var landFillCard: InfoCard!
    
    var session = UserSession()
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    
    @IBAction func finishSession(_ sender: Any) {

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SwasteThemeColors.lavender
        
//        session.addDisposalAction(action: .Compost)
//        session.addDisposalAction(action: .Compost)
//        session.addDisposalAction(action: .Compost)
//        session.addDisposalAction(action: .Recycle)
//        session.addDisposalAction(action: .Recycle)
//        session.addDisposalAction(action: .Recycle)
//        session.upload(withUserID: "Brian's iPhone")
        
        setupSocketConnection()
        
        objectDetector.cameraView = previewView
        objectDetector.delegate = self
        objectDetector.start()
        
        recycleCard = InfoCard(caption: "Recycle", frame: CGRect(x: 0, y: 0, width: 600, height: 400), color: SwasteThemeColors.blue, targetLocation: CGPoint(x: view.frame.size.width - 250, y: view.frame.size.height / 2))
        
        compostCard = InfoCard(caption: "Compost", frame: CGRect(x: 0, y: 0, width: 600, height: 400), color: SwasteThemeColors.green, targetLocation: CGPoint(x: view.frame.size.width - 250, y: view.frame.size.height / 2))
        
        landFillCard = InfoCard(caption: "Landfill", frame: CGRect(x: 0, y: 0, width: 600, height: 400), color: SwasteThemeColors.brown, targetLocation: CGPoint(x: view.frame.size.width - 250, y: view.frame.size.height / 2))

        disableFinishButton()
        view.addSubview(recycleCard)
        view.addSubview(compostCard)
        view.addSubview(landFillCard)
        
//        recycleCard.moveIntoPosition()
//        compostCard.moveIntoPosition()
//        landFillCard.moveIntoPosition()

    }
    
    fileprivate func enableFinishButton() {
        finishButton.isEnabled = true
        finishButton.isHidden = false
    }
    
    fileprivate func disableFinishButton() {
        finishButton.isEnabled = false
        finishButton.isHidden = true
    }
    
    private func setupSocketConnection() {
        guard let url = URL(string: "https://www.swaste.tech") else {
                   return
               }
               
       socket = SocketCommunicator(url: url)
       socket?.delegate = self
       socket?.connect()
    }
    
    @IBAction func send1(_ sender: Any) {
        socket?.sendData(value: 1)
    }
    
    @IBAction func send2(_ sender: Any) {
        socket?.sendData(value: 2)
    }
    
    @IBAction func send3(_ sender: Any) {
        socket?.sendData(value: 3)
    }
    @IBAction func reset1(_ sender: Any) {
        socket?.sendData(value: 4)
    }
    
    @IBAction func reset2(_ sender: Any) {
        socket?.sendData(value: 5)
    }
    @IBAction func reset3(_ sender: Any) {
        socket?.sendData(value: 6)
    }
}

extension MainViewController: SocketCommunicatorDelegate {
    func didConnect() {
        print("Socket connected!")
    }
    
    func didReceiveData(data: [Any]) {
        guard let userData = data[0] as? String else {
            print("ERROR")
            return
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        session.upload(withUserID: userData)
        disableFinishButton()
    }
    
}

extension MainViewController: ObjectDetectorDelegate {
    func promptRecycle() {
        enableFinishButton()
        if recycleCard.presenting {
            return
        }
        
        recycleCard.moveIntoPosition()
        socket?.sendData(value: 1)
        session.addDisposalAction(action: .Recycle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.recycleCard.resetPosition()
            self.socket?.sendData(value: 4)
        }
    }
    
    func promptLandfill() {
        enableFinishButton()
        if landFillCard.presenting {
            return
        }
        
        landFillCard.moveIntoPosition()
        socket?.sendData(value: 2)
        session.addDisposalAction(action: .Trash)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.landFillCard.resetPosition()
            self.socket?.sendData(value: 5)

        }
    }
    
    func promptCompost() {
        enableFinishButton()
        if compostCard.presenting {
            return
        }
        
        compostCard.moveIntoPosition()
        socket?.sendData(value: 3)
        session.addDisposalAction(action: .Compost)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.compostCard.resetPosition()
            self.socket?.sendData(value: 6)
        }
    }
}
