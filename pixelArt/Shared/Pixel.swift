//
//  Pixel.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/11/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

protocol PixelDelegate: AnyObject {
    func pixelsLoaded(_ pos: [CGPoint], color: [UIColor])
    func userCounted(_ val: Int)
}

// Model for MAIN open world
class Pixel {
    
    weak var delegate: PixelDelegate? = nil
    var ref: DatabaseReference!
    
    var positions: [CGPoint] = []
    var colors: [UIColor] = []
    
    var currentColor: UIColor = UIColor.blue
    
    private var lastPixelTime = 0
    
    // Initializer for new games
    init() {
        loadNewPixels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func loadNewPixels() {
        
        let ref = Database.database().reference().child("MainWorld/Pixels")

        ref.observe(.value, with: { snapshot in
            print("loading new pixel")
            
            let queryRef = ref.queryOrdered(byChild: "timeline").queryStarting(atValue: self.lastPixelTime+1)
            
            queryRef.observeSingleEvent(of: .value, with: { snapshot in
                print("caelandailey")
                print(snapshot.childrenCount)
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    
                    var x = 0
                    var y = 0
                    var colorIntVal = 0
                    let enumerator = snap.children
                    for cell in enumerator.allObjects as! [DataSnapshot] {
                        print(cell)
                        switch cell.key {
                            
                        case "x": x = cell.value as! Int
                        case "y": y = cell.value as! Int
                        case "timeline": self.lastPixelTime = cell.value as! Int
                        case "color": colorIntVal = cell.value as! Int
                            
                        default: break
                        }
                    }
                    print(self.lastPixelTime)
                    print("loaded new pixel")
                    let color = UIColor.init(rgb: colorIntVal)
                    if let pixelPos = self.positions.index(of: CGPoint(x:x,y:y)) {
                        if self.colors[pixelPos] == color {
                            print("contained pixel returning")
                            return
                        }
                    }
                    
                    self.positions.append(CGPoint(x:x, y:y))
                    self.colors.append(color)
                    self.delegate?.pixelsLoaded(self.positions, color: self.colors)
                }
            })
        })
    }
    
    // Used becuase we only want to load data we havent seen yet
    var timestamp: Int {
        return Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    // Uploads a pixel
    func uploadNewPixel(pos: CGPoint) {
        
        let x = Int(pos.x)
        let y = Int(pos.y)
        
        let itemRef = Database.database().reference().child("MainWorld/Pixels/\(x),\(y)")

        let val: [String: Int] = ["x":x, "y": y, "color" : currentColor.toHexInt(), "timeline": timestamp]
        itemRef.setValue(val)
        
        print("uploaded new pixel")
    }
}
