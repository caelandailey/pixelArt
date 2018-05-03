//
//  PixelPreview.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/24/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class PixelPreview: UIView {
    
    // Update if set
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
    
    // Size of the pixels
    var pixelSize: CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
  
        // If not same then dont draw
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
        
    }
}
