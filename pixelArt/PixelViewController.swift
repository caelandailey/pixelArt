//
//  ViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/9/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit

class PixelViewController: UIViewController, PixelViewDelegate, PixelDelegate {
   
    let pixel = Pixel()
    
    //private var pixelView: ViewHolder {
    private var viewHolder: ViewHolder {
        //return view as! PixelView
        return view as! ViewHolder
    }

    // Loads the view
    override func loadView() {
        
        // Create it
        //view = PixelView()
        
        view = ViewHolder()
        
        //view.backgroundColor = UIColor.white
        print("Detail view load")
    }
    
    // Load view
    override func viewDidLoad() {
        
        // Set delegates
        pixel.delegate = self
        //pixelView.delegate = self
      // pixel.loadNewPixels()
        viewHolder.pixelView.delegate = self
        
    }
    
    func cellTouchesBegan(_ pos: CGPoint, color: CGColor) {
        print("Updating model")
        // Update model
        let position = CGPoint(x: Int(pos.x), y: Int(pos.y))
        
        pixel.uploadNewPixel(pos: position)
  
        
        //pixel.loadAllPixels()
    }
    
    func pixelsLoaded(_ pos: [CGPoint], color: [CGColor]) {
        print("Updating view")
        //Update view
        viewHolder.pixelView.colorsToDraw = color
        viewHolder.pixelView.positionsToDraw = pos
    }
    
    
}

