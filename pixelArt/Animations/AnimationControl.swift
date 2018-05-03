//
//  AnimationControl.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/1/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

protocol AnimationControlDelegate: AnyObject {
    func goLeftAnimation()
    func goRightAnimation()
}

// Animation control
// Go left or go right
class AnimationControl: UIView {
    
    weak var delegate: AnimationControlDelegate?
    
    let leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "back_icon"), for: .normal)
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        return leftButton
    }()
    
    let rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "forward_icon"), for: .normal)
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        return rightButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        print(self.bounds)
        print("laying out animation control")
        leftButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        rightButton.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        
        leftButton.setNeedsDisplay()
        rightButton.setNeedsDisplay()
    }
    
    @objc
    private func leftButtonPressed() {
        print("left pressed")
        
        delegate?.goLeftAnimation()
    }
    
    @objc
    private func rightButtonPressed() {
        print("right pressed")
        delegate?.goRightAnimation()
    }
}
