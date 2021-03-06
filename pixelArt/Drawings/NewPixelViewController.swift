//
//  NewPixelViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit


class NewPixelViewController: UIViewController, PixelViewDelegate, ColorPickerControlDelegate {
    
    // Update if set
    var positions: [CGPoint] = [] {
        didSet {
            viewHolder.pixelView.positionsToDraw = positions
        }
    }
    var colors: [UIColor] = [] {
        didSet {
            viewHolder.pixelView.colorsToDraw = colors
        }
    }
    
    var currentColor: UIColor = UIColor.blue
    
    private var viewHolder: ViewHolder {
        return view as! ViewHolder
    }
    
    // Loads the view
    override func loadView() {
        view = ViewHolder(frame: UIScreen.main.bounds, sizeFactor: 1)
        
        print("Detail view load")
    }
    
    // Load view
    override func viewDidLoad() {
        // Navigation settings
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.done, target: self, action: #selector(backHandler))
  
        // Set delegates
        viewHolder.pixelView.delegate = self
        viewHolder.colorPickerControl.delegate = self
        
    }
    
    func cellTouchesBegan(_ pos: CGPoint) {

        // Update model
        let position = CGPoint(x: Int(pos.x), y: Int(pos.y))
        
        // Add to storage
        positions.append(position)
        colors.append(currentColor)
        
        // Update view
        viewHolder.pixelView.positionsToDraw = positions
        viewHolder.pixelView.colorsToDraw = colors
    }

    // Choosing a color
    func colorChosen(_ color: UIColor) {
        currentColor = color
    }
    
    func alertYesButton(action: UIAlertAction) {
        print("SAVE")
        saveDrawing()
        self.navigationController?.popViewController(animated: true)
    }
    
    // Saves a drawing
    private func saveDrawing() {
        let entry = PixelDataset.Entry(
            pixelPositions: convertCGPointToString(positions),
            pixelColors: convertColorToInt(colors)
        )
        
       PixelDataset.appendEntry(entry)
    }
    
    // Converting to cgpoint to string, needed because dataset is in STRING form
    private func convertCGPointToString(_ points: [CGPoint]) -> [String] {
        var newPoints: [String] = []
        
        for p in points {
            newPoints.append(NSStringFromCGPoint(p))
        }
        return newPoints
    }
    
    // Convert uicolor to int. Needed because dataset is in INT
    private func convertColorToInt(_ colors: [UIColor]) -> [Int] {
        var newColors: [Int] = []
        
        for c in colors {
            newColors.append(c.toHexInt())
        }
        
        return newColors
    }
    
    // Alert
    func alertNoButton(action: UIAlertAction) {
        print("dont save")
        self.navigationController?.popViewController(animated: true)
    }
    
    // Handler for backing
    @objc func backHandler() {
        let alert = UIAlertController(title: "Saving", message: "Do you want to save?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: alertYesButton))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: alertNoButton))
        self.present(alert, animated: true, completion: nil)
    }
}
