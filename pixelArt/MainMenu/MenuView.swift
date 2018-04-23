//
//  MenuView.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/22/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

protocol MenuViewDelegate: AnyObject {
    func goToDrawings()
}

class MenuView: UIView {
    
    weak var delegate: MenuViewDelegate? = nil
    
    let userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "profile_icon")
        return userImage
    }()
    let userView: UIView = {
        let userView = UIView()
        return userView
        
        
    }()
    let userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.adjustsFontSizeToFitWidth = true
        userLabel.text = "Caelan Dailey"
        
        return userLabel
    }()
    
    let drawingsButton: UIButton = {
        let drawingsButton = UIButton()
        drawingsButton.setTitle("Drawings", for: UIControlState.normal)
        drawingsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        drawingsButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        drawingsButton.backgroundColor = .black
        return drawingsButton
    }()
    let animationsButton: UIButton = {
        let animationsButton = UIButton()
        animationsButton.setTitle("Animatons", for: UIControlState.normal)
        animationsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        animationsButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        animationsButton.backgroundColor = .black
        return animationsButton
    }()
    let friendsButton: UIButton = {
        let friendsButton = UIButton()
        friendsButton.setTitle("Friends", for: UIControlState.normal)
        friendsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        friendsButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        friendsButton.backgroundColor = .black
        return friendsButton
    }()
    
    let settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.setTitle("Settings", for: UIControlState.normal)
        settingsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        settingsButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        settingsButton.backgroundColor = .black
        return settingsButton
    }()
    
    let logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setTitle("Logout", for: UIControlState.normal)
        logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        logoutButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        logoutButton.backgroundColor = .black
        return logoutButton
    }()
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(drawingsButton)
        addSubview(animationsButton)
        addSubview(settingsButton)
        addSubview(friendsButton)
        addSubview(logoutButton)
        addSubview(userView)
        userView.addSubview(userLabel)
        userView.addSubview(userImage)
        drawingsButton.addTarget(self, action: #selector(goToDrawings), for: .touchUpInside)
        self.backgroundColor = UIColor.white
        print("menuView init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let width = self.frame.width + self.frame.origin.x
        let x = self.frame.origin.x * -1
        
        userView.frame = CGRect(x: x, y: 0, width: width, height: self.frame.height/4)
        userImage.frame = CGRect(x: userView.frame.width/5, y: userView.frame.width/4, width: userView.frame.width * 3/5, height: userView.frame.width*3/5)
    
        userLabel.frame = CGRect(x: 5, y: userImage.frame.origin.y + userImage.frame.height, width: width - 10, height: userView.frame.height-(userImage.frame.origin.y + userImage.frame.height)-5)
        drawingsButton.frame = CGRect(x: x, y: userView.frame.height + userView.frame.origin.y, width: width, height: 60)
        animationsButton.frame = CGRect(x: x, y: drawingsButton.frame.height + drawingsButton.frame.origin.y, width: width, height: 60)
        friendsButton.frame = CGRect(x: x, y: animationsButton.frame.height + animationsButton.frame.origin.y, width: width, height: 60)
        settingsButton.frame = CGRect(x: x, y: friendsButton.frame.height + friendsButton.frame.origin.y, width: width, height: 60)
        logoutButton.frame = CGRect(x: x, y: settingsButton.frame.height + settingsButton.frame.origin.y, width: width, height: 60)
        
        drawingsButton.setNeedsDisplay()
        animationsButton.setNeedsDisplay()
        friendsButton.setNeedsDisplay()
        settingsButton.setNeedsDisplay()
        logoutButton.setNeedsDisplay()
    }
    
    @objc func goToDrawings() {
        print("button pressed")
        delegate?.goToDrawings()
    }
    
}
