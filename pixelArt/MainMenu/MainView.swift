//
//  MainView.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit

protocol MainViewDelegate: AnyObject {
    func goToWorld()
    func goToNewDrawing()
    func goToAnimation()
}
class MainView: UIView {
    
    weak var delegate: MainViewDelegate? = nil
    
    let worldButton: UIButton = {
        let worldButton = UIButton()
        worldButton.layer.shadowOpacity = 0.4
       worldButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        worldButton.setTitle("Join Drawing", for: UIControlState.normal)
        return worldButton
    }()
    
    let userButton: UIButton = {
        let userButton = UIButton()
        userButton.layer.shadowOpacity = 0.4
        userButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        userButton.setTitle("Create Drawing", for: UIControlState.normal)
        return userButton
    }()
    
    let animationButton: UIButton = {
        let animationButton = UIButton()
        animationButton.layer.shadowOpacity = 0.4
        animationButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        animationButton.setTitle("Create Animation", for: UIControlState.normal)
        return animationButton
    }()
    
    let appNameLabel: UILabel = {
        let appNameLabel = UILabel()
       appNameLabel.textAlignment = NSTextAlignment.center
        appNameLabel.text = "PIXEL"
        appNameLabel.font = UIFont.systemFont(ofSize: 26)
        appNameLabel.adjustsFontSizeToFitWidth = true
        return appNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(appNameLabel)
        addSubview(worldButton)
        addSubview(userButton)
        addSubview(animationButton)
        worldButton.addTarget(self, action: #selector(goToWorld), for: .touchUpInside)
        userButton.addTarget(self, action: #selector(goToNewDrawing), for: .touchUpInside)
        animationButton.addTarget(self, action: #selector(goToAnimation), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        
        print("laying out subviews")
        
        appNameLabel.frame = CGRect(x: 0, y: 2 * bounds.height/10, width: bounds.width, height: bounds.height/10)
        worldButton.frame = CGRect(x: 0, y: bounds.height/2 - bounds.height/10, width: bounds.width, height: bounds.height/10)
        userButton.frame = CGRect(x: 0, y: bounds.height/2 +  bounds.height/10, width: bounds.width, height: bounds.height/10)
        animationButton.frame = CGRect(x: 0, y: bounds.height/2 + 3 * bounds.height/10, width: bounds.width, height: bounds.height/10)
        
        appNameLabel.setNeedsDisplay()
        worldButton.setNeedsDisplay()
        userButton.setNeedsDisplay()
        animationButton.setNeedsDisplay()
    }
    
    // MODIFY BACKGROUND COLORS
    override var backgroundColor: UIColor? {
        didSet {
            worldButton.backgroundColor = UIColor.black
            userButton.backgroundColor = UIColor.black
            animationButton.backgroundColor = UIColor.black
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func goToWorld() {
        print("world button pressed")
        delegate?.goToWorld()
    }
    
    @objc private func goToNewDrawing() {
        print("new drawing button pressed")
        delegate?.goToNewDrawing()
    }
    
    @objc private func goToAnimation() {
        print("going to animation")
        delegate?.goToAnimation()
    }
    
    
}
