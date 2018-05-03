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
        incPlayerCount()
        watchUserCount()
    }
    
    func watchUserCount() {
        
        let ref = Database.database().reference().child("MainWorld/ActiveUsers")
        
        ref.observe(.value, with: { snapshot in
            print("loading new count")
            let val = Int(snapshot.childrenCount)
            self.delegate?.userCounted(val)
            })
    }
    
    func incPlayerCount() {
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("MainWorld/ActiveUsers")
    
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
                let userRef = ref.child(id)
                userRef.setValue("")
                userRef.onDisconnectRemoveValue()
                
            })

    }
    
    func decPlayerCount() {
        let ref = Database.database().reference().child("MainWorld/Count")
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if let val = currentData.value as? Int {
                
                // Set value and report transaction success
                currentData.value = val - 1
                
                return TransactionResult.success(withValue: currentData)
            }
            currentData.value = 1
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
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
                    print(snap.value)
                    
                    
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
    
    var timestamp: Int {
        return Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func uploadNewPixel(pos: CGPoint) {
        
        let x = Int(pos.x)
        let y = Int(pos.y)
        
        let itemRef = Database.database().reference().child("MainWorld/Pixels/\(x),\(y)")

        let val: [String: Int] = ["x":x, "y": y, "color" : currentColor.toHexInt(), "timeline": timestamp]
        itemRef.setValue(val)
        
        print("uploaded new pixel")
    }
}
