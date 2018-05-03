//
//  pixelView.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/11/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

protocol PixelViewDelegate: AnyObject {
    func cellTouchesBegan(_ pos: CGPoint)
}

class PixelView: UIView {
    
    var colorsToDraw: [UIColor] = []
    {
        didSet {
            print("colorsToDraw updated")

            setNeedsDisplay()
        }
    }
    var positionsToDraw: [CGPoint] = []
    {
        didSet {
            print("positionsToDraw updated")
            setNeedsDisplay()
        }
    }
   
    var pixelSize: CGFloat = 2
    
    weak var delegate: PixelViewDelegate? = nil
    
    override func draw(_ rect: CGRect) {

        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        

        // Check error
        if (colorsToDraw.count != positionsToDraw.count) {
            print("ERROR count doesnt match")
            return
        }
        // GRIDS
        if (pixelSize > 4) {
            for i in 0..<Int(self.bounds.width) {
                if (i % Int(pixelSize) == 0 || i % Int(pixelSize) == Int(pixelSize-1)) {
                    context.setFillColor(UIColor(red: 240/256, green: 240/256, blue: 240/256, alpha: 1.0).cgColor)
                    let frame = CGRect(x: i, y: 0, width: 1, height: Int(self.bounds.height))
                    context.fill(frame)
                }
                
            }
            for j in 0..<Int(self.bounds.height) {
                if (j % Int(pixelSize) == 0 || j % Int(pixelSize) == Int(pixelSize-1)) {
                    context.setFillColor(UIColor(red: 240/256, green: 240/256, blue: 240/256, alpha: 1.0).cgColor)
                    let frame = CGRect(x: 0, y: j, width: Int(self.bounds.width), height: 1)
                    context.fill(frame)
                }
                
            }
        }
        
        // Loop through
        for i in 0..<colorsToDraw.count {
            context.setFillColor(colorsToDraw[i].cgColor)
            let frame = CGRect(x: positionsToDraw[i].x * pixelSize, y: positionsToDraw[i].y * pixelSize, width: pixelSize, height: pixelSize)
            context.fill(frame)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touches began")

        let touch: UITouch = touches.first!
        let pos: CGPoint = touch.location(in: self)
        let updatedPos = CGPoint(x: pos.x/pixelSize, y: pos.y/pixelSize)
        
        
        delegate?.cellTouchesBegan(updatedPos)
    }
}
