//
//  OfflineAnimationViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/2/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//


class OfflineAnimationViewController: UIViewController, PixelViewDelegate, ColorPickerControlDelegate, AnimationControlDelegate {
    func goLeftAnimation() {
        if (pagePosition == 0) {
            return
        }
        
        colors.removeAll()
        positions.removeAll()
        
        viewHolder.pixelView.colorsToDraw.removeAll()
        viewHolder.pixelView.positionsToDraw.removeAll()
    }
    
    func goRightAnimation() {
        print("went right animation")
        pagePositions.append(positions)
        pageColors.append(colors)
        
        colors.removeAll()
        positions.removeAll()
        
        viewHolder.pixelView.colorsToDraw.removeAll()
        viewHolder.pixelView.positionsToDraw.removeAll()
        pagePosition = pagePosition + 1
        
    }
    
    
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
    var pagePositions: [[CGPoint]] = [] {
        didSet {
            
        }
    }
    
    var pageColors: [[UIColor]] = [] {
        didSet {
        
        }
    }
    
    var pagePosition = 0
    
    var currentColor: UIColor = UIColor.blue
    
    private var viewHolder: AnimationsViewHolder {
        return view as! AnimationsViewHolder
    }
    
    // Loads the view
    override func loadView() {
        view = AnimationsViewHolder(frame: UIScreen.main.bounds, sizeFactor: 1)
        
        print("Detail view load")
    }
    
    // Load view
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.done, target: self, action: #selector(backHandler))
        
        viewHolder.pixelView.delegate = self
        viewHolder.colorPickerControl.delegate = self
        viewHolder.animationControl.delegate = self
    }
    
    func cellTouchesBegan(_ pos: CGPoint) {
        print("Updating model")
        // Update model
        let position = CGPoint(x: Int(pos.x), y: Int(pos.y))
        positions.append(position)
        colors.append(currentColor)
        
        viewHolder.pixelView.positionsToDraw = positions
        viewHolder.pixelView.colorsToDraw = colors
    }
    
    func cellTouchesEnded() {
        
    }
    
    func colorChosen(_ color: UIColor) {
        currentColor = color
        print("Color chosen!")
        
    }
    
    func alertYesButton(action: UIAlertAction) {
        print("SAVE")
        saveDrawing()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func saveDrawing() {
        if (pagePositions.count == pagePosition) {
            print("caelandailey")
            pagePositions.append(positions)
            pageColors.append(colors)
        }
        print("yes@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        print(pagePosition)
        print(pagePositions.count)
        let entry = AnimationDataset.Entry(
            pixelPositions: convertCGPointToString(pagePositions),
            pixelColors: convertColorToInt(pageColors)
        )
        
        AnimationDataset.appendEntry(entry)
    }
    
    private func convertCGPointToString(_ points: [[CGPoint]]) -> [[String]] {
        
        /*
        var newPoints: [[String]] = Array(repeating: Array(repeating: "0", count: points[0].count), count: points.count)
        
        for x in 0..<points.count {
            for y in 0..<points[x].count {
                newPoints[x][y] = NSStringFromCGPoint(points[x][y])
            }
        }
        
        print(newPoints)
        
        return newPoints
 */
        
        var pointsD1: [String] = []
        var pointsD2: [[String]] = []
        for x in points {
            for y in x {
                pointsD1.append(NSStringFromCGPoint(y))
            }
            pointsD2.append(pointsD1)
            pointsD1.removeAll()
        }
        
        return pointsD2
    }
    
    private func convertColorToInt(_ colors: [[UIColor]]) -> [[Int]] {
        
        var colorsD1: [Int] = []
        var colorsD2: [[Int]] = []
        for x in colors {
            for y in x {
                colorsD1.append(y.toHexInt())
            }
            colorsD2.append(colorsD1)
            colorsD1.removeAll()
        }
        
        return colorsD2
    }
    
    func alertNoButton(action: UIAlertAction) {
        print("dont save")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func backHandler() {
        let alert = UIAlertController(title: "Saving", message: "Do you want to save?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: alertYesButton))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: alertNoButton))
        self.present(alert, animated: true, completion: nil)
    }
}
