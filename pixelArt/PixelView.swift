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
    func cellTouchesBegan(_ pos: CGPoint, color: CGColor)
}

class PixelView: UIView {
    
    var colorsToDraw: [CGColor] = []
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
    
    var currentColor = UIColor.black.cgColor
    
    private var pixelSize: CGFloat = 3
    
    weak var delegate: PixelViewDelegate? = nil
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("Attempting to draw")
        if(colorsToDraw.count == 0) {
            return
        }
        
        print("before context")
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
    print("Drawing view")
        // Check error
        if (colorsToDraw.count != positionsToDraw.count) {
            print("ERROR count doesnt match")
            return
        }
        // GRIDS
        /*
        for i in 0..<Int(self.bounds.width) {
            if (i & 1 == 0) {
                continue
            }
            context.setFillColor(UIColor(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0).cgColor)
            let frame = CGRect(x: i, y: 0, width: 1, height: Int(self.bounds.height))
            context.fill(frame)
        }
        for j in 0..<Int(self.bounds.height) {
            if (j & 1 == 0) {
                continue
            }
            context.setFillColor(UIColor(red: 250/256, green: 250/256, blue: 250/256, alpha: 1.0).cgColor)
            let frame = CGRect(x: 0, y: j, width: Int(self.bounds.width), height: 1)
            context.fill(frame)
        }
 */
        // Loop through
        for i in 0..<colorsToDraw.count {
            context.setFillColor(colorsToDraw[i])
            let frame = CGRect(x: positionsToDraw[i].x * pixelSize, y: positionsToDraw[i].y * pixelSize, width: pixelSize, height: pixelSize)
            context.fill(frame)
        }
        
      
        
        //colorsToDraw.removeAll()
        //positionsToDraw.removeAll()
        
        
        
        print("Updated view")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touches began")

        let touch: UITouch = touches.first!
        let pos: CGPoint = touch.location(in: self)
        let updatedPos = CGPoint(x: pos.x/pixelSize, y: pos.y/pixelSize)
        delegate?.cellTouchesBegan(updatedPos, color: currentColor)
    }
    
}
