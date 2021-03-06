//
//  AnimationTableviewController.swift
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

// Class for animation table
// IS ONLINE
class AnimationTableViewController: UITableViewController {
    
    var timerCount = 0
    
    var animationTimer: Timer!
    // Array of ANIMATIONS, with array of PAGES, with array of COLORS
    var drawingsColor: [[[UIColor]]] = [] {
        didSet {
            datasetUpdated()
        }
    }
    
    // Array of ANIMATIONS, with array of PAGES, with array of POSITIONS
    var drawingsPosition: [[[CGPoint]]] = [] {
        didSet {
            datasetUpdated()
        }
    }
  
    var drawingsRef: [String] = []
    
    var count = 0
    
    // Update on main thread
    func datasetUpdated() {
        DispatchQueue.main.async(){
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
            print("called to update ~!!!!~!~")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerCount), userInfo: nil, repeats: true)
        print("viewdidAppear")
    }
    
    @objc private func updateTimerCount() {
        timerCount = timerCount + 1
        datasetUpdated()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets animation data
        loadData()
        
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animationTimer.invalidate()
        
    }
    
    private func loadData() {
        
        drawingsColor.removeAll()
        drawingsPosition.removeAll()
        
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("\(id)").child("Animations")
        
        ref.observe(.value, with: { snapshot in

            self.count = Int(snapshot.childrenCount)
 
            for child in snapshot.children {
                
                var pagesColor: [[UIColor]] = []
                
                var pagesPosition: [[CGPoint]] = []
                    
                let theChild = child as! DataSnapshot
                self.drawingsRef.append(theChild.key)
                for page in theChild.children {
                    
                    var snap = page as! DataSnapshot
                    
                    snap = snap.childSnapshot(forPath: "Pixels")
                    
                    let enumerator = snap.children
                    var colors: [UIColor] = []
                    var positions: [CGPoint] = []
                    
                    for cells in enumerator.allObjects as! [DataSnapshot] {

                        var x = 0
                        var y = 0
                        var colorIntVal = 0
                        
                        for cell in cells.children.allObjects as! [DataSnapshot] {
                            
                            switch cell.key {
                                
                            case "x": x = cell.value as! Int
                            case "y": y = cell.value as! Int
                            case "color": colorIntVal = cell.value as! Int
                                
                            default: break
                            }
                        }
                        colors.append(UIColor.init(rgb: colorIntVal))
                        positions.append(CGPoint(x:x,y:y))
                        
                    }
                    
                    pagesColor.append(colors)
                    pagesPosition.append(positions)
                    
                }
                self.drawingsColor.append(pagesColor)
                self.drawingsPosition.append(pagesPosition)
            }
            
        })
        print("finished loading data")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == self.tableView, section == 0 else {
            return 0
        }
        
        return count
    }
    
    // THIS CREATES THE CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === self.tableView, indexPath.section == 0 else {
            return UITableViewCell()
            
        }
        
        if (drawingsColor.count <= indexPath.row) {
            return UITableViewCell()
        }
        let cell: UITableViewCell = UITableViewCell()
        
        cell.backgroundColor = UIColor.groupTableViewBackground
        
        
        // Add preview
        
        let pixelPreview = PixelPreview()
        pixelPreview.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height )
        let pageCount = drawingsColor[indexPath.row].count
        
        pixelPreview.colorsToDraw = drawingsColor[indexPath.row][timerCount % pageCount ]
        pixelPreview.positionsToDraw = drawingsPosition[indexPath.row][timerCount % pageCount ]
        pixelPreview.backgroundColor = UIColor.white
        pixelPreview.layer.borderWidth = 1
        pixelPreview.layer.borderColor = UIColor.black.cgColor
        cell.addSubview(pixelPreview)
 
        return cell
    }
    
    // Need conversion because of dataset value types
    private func convertStringToCGPoint(_ points: [String]) -> [CGPoint] {
        var newPoints: [CGPoint] = []
        
        for p in points {
            newPoints.append(CGPointFromString(p))
        }
        return newPoints
    }
    
    private func convertIntToColor(_ colors: [Int]) -> [UIColor] {
        var newColors: [UIColor] = []
        
        for c in colors {
            newColors.append(UIColor.init(rgb: c))
        }
        
        return newColors
    }
    
    
    // Allows editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // if deleting
        if (editingStyle == .delete) {
            // delete entry
            PixelDataset.deleteEntry(atIndex: indexPath.row)
            // Update table
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    // GO TO EDIT
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView === self.tableView, indexPath.section == 0 else {
            return
        }

        // Get VC based on row
        let vc: OnlineAnimationViewController = OnlineAnimationViewController(withRef: drawingsRef[indexPath.row])

        // Load
        vc.pixel.loadNewPixels()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

