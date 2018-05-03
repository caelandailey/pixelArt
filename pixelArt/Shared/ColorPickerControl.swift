//
//  ColorPickerControl.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/19/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

protocol ColorPickerControlDelegate: AnyObject {
    func colorChosen(_ color: UIColor)
}

// Control for picking a color
class ColorPickerControl: UIControl {
    
    let cols = 5
    let rows = 2
    let colors: [UIColor] = [UIColor.black, UIColor.blue, UIColor.brown,  UIColor.green, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.red, UIColor.yellow, UIColor.white]
    
    weak var delegate: ColorPickerControlDelegate? = nil
    
    
    override func draw(_ rect: CGRect) {
        
        guard let context:CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.clear(bounds)
        print("caelan")
        for i in 0..<rows {
            for j in 0..<cols {
                print(i * cols + j)
                context.setFillColor(colors[ i*cols + j].cgColor)
                let width = bounds.width/CGFloat(cols)
                let height = bounds.height/CGFloat(rows)
                let frame = CGRect(x: width * CGFloat(j), y: height * CGFloat(i), width: width, height: height)
                context.fill(frame)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch: UITouch = touches.first!
        let pos: CGPoint = touch.location(in: self)
        
        let width = bounds.width/CGFloat(cols)
        let height = bounds.height/CGFloat(rows)
        
        let x = Int(pos.x / width)
        let y = Int(pos.y / height)
        let color = colors[x + y * cols]
        
        delegate?.colorChosen(color)
        
    }
}
