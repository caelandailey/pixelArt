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
    
    var positions: [CGPoint] = []
    var colors: [CGColor] = []
    
    private var lastPixelTime = 0
    
    // Initializer for new games
    init() {
        loadNewPixels()
        //loadAllPixels()
        //loadNewPixel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
/*
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
    */
    func loadNewPixels() {
        
        let ref = Database.database().reference()

        ref.observe(.value, with: { snapshot in
            print("loading new pixel")
            
            let queryRef = ref.queryOrdered(byChild: "timeline").queryStarting(atValue: self.lastPixelTime+1)
            
            queryRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    print(snap.value)
                    
                    
                    var x = 0
                    var y = 0
                    let enumerator = snap.children
                    for cell in enumerator.allObjects as! [DataSnapshot] {
                        print(cell)
                        switch cell.key {
                            
                        case "x": x = cell.value as! Int
                        case "y": y = cell.value as! Int
                        case "timeline": self.lastPixelTime = cell.value as! Int
                            
                            
                        default: break
                        }
                    }
                    print(self.lastPixelTime)
                    print("loaded new pixel")
                    let color = UIColor.black.cgColor
                    if let pixelPos = self.positions.index(of: CGPoint(x:x,y:y)) {
                        if self.colors[pixelPos] == color {
                            print("contained pixel returning")
                            return
                        }
                    }
             
                    
                    self.positions.append(CGPoint(x:x, y:y))
                    
                    self.colors.append(UIColor.black.cgColor)
                    
                    self.delegate?.pixelsLoaded(self.positions, color: self.colors)
                    
                    //self.positions.removeAll()
                    //self.colors.removeAll()
                }
            })
            
        })
        
    }
    
    /*
    func loadNewPixel() {
        
        print("attempting to load new pixel")
        let ref = Database.database().reference()
        
        ref.observe(.childAdded, with: { snapshot in
            print("loading new pixel")
            
            
            let queryRef = ref.queryOrdered(byChild: "timeline").queryLimited(toFirst: 1)
            
            queryRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    print(snap.value)
                    
                    
                    var x = 0
                    var y = 0
                    let enumerator = snap.children
                    for cell in enumerator.allObjects as! [DataSnapshot] {
                        print(cell)
                        switch cell.key {
                            
                        case "x": x = cell.value as! Int
                        case "y": y = cell.value as! Int
                        
                        default: break
                        }
                    }
                    
                    print("loaded new pixel")
                    
                    if (self.positions.contains(CGPoint(x:x, y:y))) {
                        return
                    }
                    
                    self.positions.append(CGPoint(x:x, y:y))
                    
                    self.colors.append(UIColor.black.cgColor)
                    
                    self.delegate?.pixelsLoaded(self.positions, color: self.colors)
                    
                    //self.positions.removeAll()
                    //self.colors.removeAll()
                }
            })
            
            
        })
    }
    */
    var timestamp: Int {
        return Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func uploadNewPixel(pos: CGPoint) {
        
        let x = Int(pos.x)
        let y = Int(pos.y)
        
        let itemRef = Database.database().reference().child("\(x),\(y)")
        
        let val: [String: Int] = ["x":x, "y": y, "timeline": timestamp]
        itemRef.setValue(val)
        //itemRef.child("hex").setValue(blockColor)
        //itemRef.child("x").setValue(x)
        //itemRef.child("y").setValue(y)
       // itemRef.child("timeline").setValue(timestamp)
        
        print("uploaded new pixel")
    }
}
