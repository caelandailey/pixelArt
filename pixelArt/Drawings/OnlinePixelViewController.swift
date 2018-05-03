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

// Viewcontroller for online drawings. Saves everything into the database
class OnlinePixelViewController: UIViewController, PixelViewDelegate, FriendsPixelDelegate, ColorPickerControlDelegate {
    
    // Count users
    func userCounted(_ val: Int) {
        playerCountView.title.text = String(val)
        playerCountView.setNeedsDisplay()
    }
    
    // Model
    let pixel = FriendsPixel()
    var ref = ""
    
    // Count view
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
    
    // The ref
    // "" = new
    // "-9gdfg8FGfH9dd" etc = existing drawing
    init(withRef: String) {

       // drawingRef = withRef
        super.init(nibName: nil, bundle: nil)
        pixel.loadRef(withRef)
        ref = withRef
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Loads the view
    override func loadView() {
        view = ViewHolder(frame: UIScreen.main.bounds, sizeFactor: 1)
        
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
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        // remove listenrs and player count
        let userRef = Database.database().reference().child("\(id)/\(ref)/ActiveUsers/\(id)")
        userRef.removeValue()
        Database.database().reference().removeAllObservers()
        print("viewWilldissappear from friendspixel")
    }
    
}
