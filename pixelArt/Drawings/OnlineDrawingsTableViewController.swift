//
//  OnlineDrawingsTableViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/25/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

// Tableview for drawings that are ONLINE
class OnlineDrawingsTableViewController: UITableViewController{
    

    var drawingsColor: [[UIColor]] = [] {
        didSet {
            datasetUpdated()
        }
    }
    
    var drawingsPosition: [[CGPoint]] = [] {
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
        print("viewdidAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        // For the tab bar
        self.title = "Online"
    }
    
    // Loads all the information for the online drawings for the specific user
    // Will be very confusing without knowing what database looks like
    // Users->DrawingsList->Drawing->Pixels->
    private func loadData() {
        
        // Loading all data so remove if any
        drawingsColor.removeAll()
        drawingsPosition.removeAll()
        
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Get ref
        let ref = Database.database().reference().child("\(id)").child("Drawings")
        
        ref.observe(.value, with: { snapshot in

            // get count of drawings
            self.count = Int(snapshot.childrenCount)
           
            // GO through drawings
            for child in snapshot.children {
                var snap = child as! DataSnapshot
                
                // Add ref of drawing so we can edit drawing if needed
                self.drawingsRef.append(snap.key)
                
                // Go to pixels and not onlineUSERS or anything else
                snap = snap.childSnapshot(forPath: "Pixels")
                
                let enumerator = snap.children
                var colors: [UIColor] = []
                var positions: [CGPoint] = []
                
                // Go through cells
                for cells in enumerator.allObjects as! [DataSnapshot] {
                    
                    var x = 0
                    var y = 0
                    var colorIntVal = 0
                    
                    // Go through single cell for each value
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
                self.drawingsColor.append(colors)
                self.drawingsPosition.append(positions)
            }
        })
    }
    
    @objc func updateTable(sender: UIButton) {
        datasetUpdated()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == self.tableView, section == 0 else {
            return 0
        }
        
        return count
    }
    
    // THIS CREATES THE CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < drawingsColor.count, indexPath.row < drawingsPosition.count  else {
            return UITableViewCell()
            print("returned")
        }
        let cell: UITableViewCell = UITableViewCell()
        
        cell.backgroundColor = UIColor.groupTableViewBackground
        
        // Add preview
        let pixelPreview = PixelPreview()
        pixelPreview.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height )
        
        pixelPreview.colorsToDraw = drawingsColor[indexPath.row]
        pixelPreview.positionsToDraw = drawingsPosition[indexPath.row]
        pixelPreview.backgroundColor = UIColor.white
        pixelPreview.layer.borderWidth = 1
        pixelPreview.layer.borderColor = UIColor.black.cgColor
        cell.addSubview(pixelPreview)
    
        return cell
    }
    
    // Conversion because the dataset has different format
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
    
    // If we can edit then check editing style
    // THIS WORKS ON ALARMTABLE BUT NOT EVENT TABLE
    // WHY?
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
 
        let vc: OnlinePixelViewController = OnlinePixelViewController(withRef: drawingsRef[indexPath.row])

        vc.pixel.loadNewPixels()
        
        navigationController?.pushViewController(vc, animated: true)
    }

}
