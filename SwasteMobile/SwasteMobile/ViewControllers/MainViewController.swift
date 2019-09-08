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
    var objectDetector = ObjectDetector()
    
    var recycleCard: InfoCard!
    var compostCard: InfoCard!
    var landFillCard: InfoCard!
    var session = UserSession()
    
    var isInActiveSession = false
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var purpleOverlay: UIView!
    @IBOutlet weak var swasteLogo: UIImageView!
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var logoText: UILabel!
    
    @IBAction func finishSession(_ sender: Any) {
        objectDetector.pause()

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.updateUIForFinishedSession()
        }
    }
    
    @IBAction func didTapScreen(_ sender: Any) {
        print("TAP")
        resetSession()
        minimizeInstructionScreen()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func resetSession() {
        session = UserSession()
        objectDetector.resume()
        setupViews()
    }
    
    private func setupInstructionScreen() {
        purpleOverlay.frame = view.frame
        
        instructionText.translatesAutoresizingMaskIntoConstraints = false
        instructionText.textAlignment = .center
        instructionText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        instructionText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        instructionText.isHidden = false

        swasteLogo.frame = CGRect(x: view.center.x - 280, y: view.center.y - 250, width: 200, height: 200)
        
        logoText.font = UIFont(name: "Futura", size: 100)
        logoText.frame = CGRect(x: view.center.x - 130, y: view.center.y - 315, width: 400, height: 300)
    }
    
    private func minimizeInstructionScreen() {

        instructionText.isHidden = true
        
        UIView.animate(withDuration: 1) {
            self.logoText.alpha = 0
            self.purpleOverlay.frame = CGRect(x: 0, y: 100, width: 270, height: 100)
            self.swasteLogo.frame = CGRect(x: 10, y: 10, width: 100, height: 80)
            self.logoText.font = UIFont(name: "Futura", size: 45)
            self.logoText.frame = CGRect(x: 60, y: 5, width: 200, height: 80)
        }
        
        UIView.animate(withDuration: 4) {
            self.logoText.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SwasteThemeColors.lavender
        disableFinishButton()
        objectDetector.cameraView = previewView
        view.sendSubviewToBack(previewView)
        objectDetector.delegate = self
        
        setupInstructionScreen()
        setupSocketConnection()

        objectDetector.start()
        objectDetector.pause()
    }
    
    private func setupViews() {
        recycleCard = InfoCard(caption: "Recycle", frame: CGRect(x: 0, y: 0, width: 600, height: 400), color: SwasteThemeColors.blue, targetLocation: CGPoint(x: view.frame.size.width - 250, y: view.frame.size.height / 2))
        
        compostCard = InfoCard(caption: "Compost", frame: CGRect(x: 0, y: 0, width: 600, height: 400), color: SwasteThemeColors.green, targetLocation: CGPoint(x: view.frame.size.width - 250, y: view.frame.size.height / 2))
        
        landFillCard = InfoCard(caption: "Trash", frame: CGRect(x: 0, y: 0, width: 600, height: 400), color: SwasteThemeColors.brown, targetLocation: CGPoint(x: view.frame.size.width - 250, y: view.frame.size.height / 2))

        disableFinishButton()
        view.addSubview(recycleCard)
        view.addSubview(compostCard)
        view.addSubview(landFillCard)
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
    
    fileprivate func updateUIForFinishedSession() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        disableFinishButton()
        setupInstructionScreen()
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
        
        session.upload(withUserID: userData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateUIForFinishedSession()
        }
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
