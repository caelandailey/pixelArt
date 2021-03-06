//
//  AnimationPixel.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/1/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol AnimationPixelDelegate: AnyObject {
    func pixelsLoaded(_ pos: [CGPoint], color: [UIColor])
    func userCounted(_ val: Int)
}

// MODEL for animations
class AnimationPixel {
    
    weak var delegate: AnimationPixelDelegate? = nil
    var ref: DatabaseReference!
    
    var positions: [CGPoint] = []
    var colors: [UIColor] = []
    
    var currentColor: UIColor = UIColor.blue
    
    private var lastPixelTime = 0
    
    var pixelRef: DatabaseReference?
    var refString: String = ""
    var pagePosition = 0
    
    
    func incPage() {
        pagePosition = pagePosition + 1
        lastPixelTime = 0
    }
    
    func decPage() {
        pagePosition = pagePosition - 1
        lastPixelTime = 0
    }
    
    func watchUserCount() {
        guard let ref = pixelRef else {
            
            return
        }
        
        
        ref.child("ActiveUsers").observe(.value, with: { snapshot in
            print("loading new count")
            let val = Int(snapshot.childrenCount)
            self.delegate?.userCounted(val)
        })
    }
    
    func incPlayerCount() {
        
        guard let id = Auth.auth().currentUser?.uid, var ref = pixelRef else {
            return
        }
        
        ref = ref.child("ActiveUsers")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            let userRef = ref.child(id)
            userRef.setValue("")
            userRef.onDisconnectRemoveValue()
            
        })
        
    }
    
    func getRef() -> String {
        return refString
    }
    
    func loadRef(_ ref: String) {
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        if (ref == "") {
            pixelRef = Database.database().reference().child("\(id)").child("Animations").childByAutoId().child("\(pagePosition)")
            refString = pixelRef!.parent!.key
            
            
        } else {
            pixelRef = Database.database().reference().child("\(id)").child("Animations").child(ref).child("\(pagePosition)")
            refString = pixelRef!.parent!.key
            
        }
        
        incPlayerCount()
        watchUserCount()
        loadNewPixels()
    }
    
    
    
    func loadNewPixels() {
        
        guard var ref = pixelRef else {
            return
        }
        ref = ref.child("Pixels")
        ref.observe(.value, with: { snapshot in
            print("loading new pixel")
            
            let queryRef = ref.queryOrdered(byChild: "timeline").queryStarting(atValue: self.lastPixelTime+1)
            
            queryRef.observeSingleEvent(of: .value, with: { snapshot in
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
                    
                    //self.positions.removeAll()
                    //self.colors.removeAll()
                }
            })
            
        })
        
    }
    
    var timestamp: Int {
        return Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func uploadNewPixel(pos: CGPoint) {
        
        let x = Int(pos.x)
        let y = Int(pos.y)
        
        guard var itemRef = pixelRef else {
            return
        }
        
        itemRef = itemRef.child("Pixels").child("\(x),\(y)")
        let val: [String: Int] = ["x":x, "y": y, "color" : currentColor.toHexInt(), "timeline": timestamp]
        itemRef.setValue(val)
        
        print("uploaded new pixel")
    }
}
