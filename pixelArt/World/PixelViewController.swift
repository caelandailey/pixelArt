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

// Used for the open world

class PixelViewController: UIViewController, PixelViewDelegate, PixelDelegate, ColorPickerControlDelegate {
    
    let pixel = Pixel()
    
    
    let playerCountView: CountView = {
        let view = CountView()
        view.frame = CGRect(x: -20, y: -20, width: 40, height: 40)
        let blueColor = UIColor(red: 14/255, green: 122/255, blue: 254/255, alpha: 1.0)
        view.image.setImageColor(color: blueColor)
        view.title.textColor = blueColor
        return view
    }()
    
    
    private var viewHolder: ViewHolder {
        return view as! ViewHolder
    }
    
    // OVERLOADS: ______________________________________
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("MainWorld/ActiveUsers/\(id)")
        ref.removeValue()
        Database.database().reference().removeAllObservers()
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
        
        
        
        let barButton = UIBarButtonItem.init(customView: playerCountView)
        self.navigationItem.rightBarButtonItem = barButton
        
        let asked = UserDefaults.standard.bool(forKey: "instructionsShowed")
        if (asked != true) {
            UserDefaults.standard.set(true, forKey: "instructionsShowed")
            showMessage()
        }
        
    }
    
    // Set the player count text
    func userCounted(_ val: Int) {
        playerCountView.title.text = String(val)
        playerCountView.setNeedsDisplay()
    }
    
    // Show instructions on how to play
    func showMessage() {
        let alert = UIAlertController(title: "Instructions", message: "The dimensions of the world is 800x1220 pixels. If you don't see anything, try zooming in!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Updates the model
    func cellTouchesBegan(_ pos: CGPoint) {

        let position = CGPoint(x: Int(pos.x), y: Int(pos.y))
        pixel.positions.append(position)
        pixel.colors.append(pixel.currentColor)
        viewHolder.pixelView.positionsToDraw = pixel.positions
        viewHolder.pixelView.colorsToDraw = pixel.colors

        pixel.uploadNewPixel(pos: position)
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
    
    
}

