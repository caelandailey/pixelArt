//
//  ViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/9/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PixelViewController: UIViewController, PixelViewDelegate, PixelDelegate {
   
    let pixel = Pixel()
    
    private var viewHolder: ViewHolder {
        return view as! ViewHolder
    }

    // Loads the view
    override func loadView() {
        view = ViewHolder()
        print("Detail view load")
    }
    
    // Load view
    override func viewDidLoad() {
        
        // Set delegates
        pixel.delegate = self
        viewHolder.pixelView.delegate = self
    }
    
    func cellTouchesBegan(_ pos: CGPoint, color: CGColor) {
        print("Updating model")
        // Update model
        let position = CGPoint(x: Int(pos.x), y: Int(pos.y))
        pixel.positions.append(position)
        pixel.colors.append(color)
        viewHolder.pixelView.positionsToDraw = pixel.positions
        viewHolder.pixelView.colorsToDraw = pixel.colors
        
        pixel.uploadNewPixel(pos: position)
    }
    
    func pixelsLoaded(_ pos: [CGPoint], color: [CGColor]) {
        print("Updating view")
        //Update view
        viewHolder.pixelView.colorsToDraw = color
        viewHolder.pixelView.positionsToDraw = pos
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Database.database().reference().removeAllObservers()
    }
    
}

