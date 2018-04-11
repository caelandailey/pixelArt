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
    func pixelsLoaded(_ pos: [CGPoint], color: [CGColor])
}
class Pixel {
    
    weak var delegate: PixelDelegate? = nil
    var ref: DatabaseReference!
    
    private var positions: [CGPoint] = []
    private var colors: [CGColor] = []
    
    // Initializer for new games
    init() {
        
        loadAllPixels()
        //loadNewPixel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAllPixels() {
        print("Attempting to load all pixels")
        let ref = Database.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            let enumerator = snapshot.children
            
            while let obj = enumerator.nextObject() as? DataSnapshot {
                
                var x = 0
                var y = 0
                //var hex = 0
                
                for cell in obj.children.allObjects as! [DataSnapshot] {
                    
                    switch cell.key {
                    //case "hex": hex = cell.value as! Int
                    case "x": x = cell.value as! Int
                    case "y": y = cell.value as! Int
                    default: break
                    }
                }
                
                self.positions.append(CGPoint(x: x, y: y))
                self.colors.append(UIColor.black.cgColor)
   
            }
            print("Loaded all pixels")

            self.delegate?.pixelsLoaded(self.positions, color: self.colors)
            //self.positions.removeAll()
            //self.colors.removeAll()
                
            
        }){ (error) in
            print(error)
        }
       
       
    }
    
    func loadNewPixel() {
        print("attempting to load new pixel")
        let ref = Database.database().reference()
        
        ref.queryOrdered(byChild: "timeline").queryLimited(toFirst: 2).observe(.childAdded, with: { snapshot in
            print("loading new pixel")
            let enumerator = snapshot.children
            print(enumerator.allObjects)
            
            var x = 0
            var y = 0
            
            for cell in enumerator.allObjects as! [DataSnapshot] {
                print(cell)
                switch cell.key {
                    
                case "x": x = cell.value as! Int
                case "y": y = cell.value as! Int
                default: break
                }
            }
            
            print("loaded new pixel")
            
            self.positions.append(CGPoint(x:x, y:y))
            print(self.positions)
            self.colors.append(UIColor.black.cgColor)
            self.delegate?.pixelsLoaded(self.positions, color: self.colors)
            
            //self.positions.removeAll()
            //self.colors.removeAll()
            
        })
    }
    
    var timestamp: Int {
        return 0 - Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func uploadNewPixel(pos: CGPoint) {
        
        let x = Int(pos.x)
        let y = Int(pos.y)
        
        let itemRef = Database.database().reference().child("\(x),\(y)")
        
        //itemRef.child("hex").setValue(blockColor)
        itemRef.child("x").setValue(x)
        itemRef.child("y").setValue(y)
        itemRef.child("timeline").setValue(timestamp)
        
        print("uploaded new data")
    }
}
