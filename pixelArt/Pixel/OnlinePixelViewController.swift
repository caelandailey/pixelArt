//
//  OnlinePixelViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/25/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class OnlinePixelViewController: UIViewController, PixelViewDelegate, FriendsPixelDelegate, ColorPickerControlDelegate {
    
    let pixel = FriendsPixel()
    
    private var viewHolder: ViewHolder {
        return view as! ViewHolder
    }
    
    // Loads the view
    override func loadView() {
        view = ViewHolder(frame: UIScreen.main.bounds, sizeFactor: 5)
        
        print("Detail view load")
    }
    
    // Load view
    override func viewDidLoad() {
        
        // Set delegates
        pixel.delegate = self
        
        viewHolder.pixelView.delegate = self
        viewHolder.colorPickerControl.delegate = self
    }
    
    func cellTouchesBegan(_ pos: CGPoint) {
        print("Updating model")
        // Update model
        let position = CGPoint(x: Int(pos.x), y: Int(pos.y))
        pixel.positions.append(position)
        pixel.colors.append(pixel.currentColor)
        viewHolder.pixelView.positionsToDraw = pixel.positions
        viewHolder.pixelView.colorsToDraw = pixel.colors
        
        pixel.uploadNewPixel(pos: position)
    }
    
    func cellTouchesEnded() {
        // viewHolder.isScrollEnabled = true
    }
    
    func pixelsLoaded(_ pos: [CGPoint], color: [UIColor]) {
        print("Updating view")
        //Update view
        viewHolder.pixelView.colorsToDraw = color
        viewHolder.pixelView.positionsToDraw = pos
    }
    
    func colorChosen(_ color: UIColor) {
        pixel.currentColor = color
        print("Color chosen!")
        print(color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Database.database().reference().removeAllObservers()
    }
    
}
