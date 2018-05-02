//
//  AnimationPreview.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/1/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class AnimationPreview: UIView {
    
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
    
    
    
    
    var pixelSize: CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        //super.draw(rect)
        
        
        print("Attempting to draw")
        print(colorsToDraw)
        print(positionsToDraw)
        
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
            context.setFillColor(colorsToDraw[i].cgColor)
            let frame = CGRect(x: positionsToDraw[i].x * pixelSize, y: positionsToDraw[i].y * pixelSize, width: pixelSize, height: pixelSize)
            context.fill(frame)
        }
        
        
        
        //colorsToDraw.removeAll()
        //positionsToDraw.removeAll()
        
        
        
        print("Updated view")
        
    }
}
