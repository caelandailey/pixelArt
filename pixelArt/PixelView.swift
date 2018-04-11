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
    
    private var pixelSize: CGFloat = 5
    
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
        
        // Loop through
        for i in 0..<colorsToDraw.count {
            context.setFillColor(colorsToDraw[i])
            let frame = CGRect(x: positionsToDraw[i].x, y: positionsToDraw[i].y, width: pixelSize, height: pixelSize)
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
        let position: CGPoint = touch.location(in: self)
        
        delegate?.cellTouchesBegan(position, color: currentColor)
    }
    
}
