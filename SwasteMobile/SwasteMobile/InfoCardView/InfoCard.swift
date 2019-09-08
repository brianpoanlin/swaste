//
//  InfoCard.swift
//  SwasteMobile
//
//  Created by Brian Lin on 9/7/19.
//  Copyright © 2019 Brian Lin. All rights reserved.
//

import UIKit

class InfoCard: UIView {
    private let captionLabel = UILabel()
    private let imageView = UIImageView()
    private var moveLocation: CGPoint!
    
    var presenting = false

    convenience init(image: UIImage? = nil, caption: String, frame: CGRect, color: UIColor? = .blue, targetLocation: CGPoint) {
        self.init(frame: frame)
        captionLabel.text = caption
        backgroundColor = color
        moveLocation = targetLocation
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 25
        captionLabel.font = UIFont(name: "Futura", size: 65)
        addSubview(captionLabel)
        captionLabel.textColor = .white
        captionLabel.alpha = 0.9
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        captionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.center = CGPoint(x: 3000, y: 1000)
    }
    
    func resetPosition() {
        UIView.animate(withDuration: 2) {
            self.center = CGPoint(x: 3000, y: 1000)
            self.alpha = 0
            self.presenting = false
        }
    }
    
    func moveIntoPosition() {
        UIView.animate(withDuration: 1) {
            self.center = self.moveLocation
            self.alpha = 0.9
            self.presenting = true
        }
    }
}
