//
//  OfflineAnimationTableViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/2/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

// Tableview for OFFLINE animations
class OfflineAnimationsTableViewController: UITableViewController, PixelDatasetDelegate {
    
    private static var cellReuseIdentifier = "OfflineAnimationsTableViewController.DatasetItemsCellIdentifier"
    
    let delegateID: String = UIDevice.current.identifierForVendor!.uuidString
    var timerCount = 0
    
    // Time to create animation
    var animationTimer: Timer!
    
    // Update value
    // Later on we access a position in an array based on timerCount
    // We travel through an array with this
    @objc private func updateTimerCount() {
        print("updated timer")
        timerCount = timerCount + 1
        datasetUpdated()
    }
    
    // Update on main thread
    func datasetUpdated() {
        DispatchQueue.main.async(){
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    // Cancel timer
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animationTimer.invalidate()
        
    }
    
    // Set timer
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerCount), userInfo: nil, repeats: true)
        datasetUpdated()
    }
    
    // Get data
    override func viewDidLoad() {
        super.viewDidLoad()
        AnimationDataset.registerDelegate(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: OfflineAnimationsTableViewController.cellReuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == self.tableView, section == 0 else {
            return 0
        }
        
        return AnimationDataset.count
    }
    
    // THIS CREATES THE CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < AnimationDataset.count  else {
            return UITableViewCell()
        }
        let cell: UITableViewCell = UITableViewCell()
        
        cell.backgroundColor = UIColor.groupTableViewBackground
        
        //Add text
        let pixelData = AnimationDataset.entry(atIndex: indexPath.row)

        // Add preview
        let pixelPreview = PixelPreview()

        pixelPreview.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height )

        // Get values
        let pageCount = pixelData.pixelColors.count
        let colors = convertIntToColor(pixelData.pixelColors)
        let positions = convertStringToCGPoint(pixelData.pixelPositions)
        
        // Add them
        pixelPreview.colorsToDraw = colors[timerCount % pageCount]
        pixelPreview.positionsToDraw = positions[timerCount % pageCount]
        
        // Make look pretty
        pixelPreview.backgroundColor = UIColor.white
        pixelPreview.layer.borderWidth = 1
        pixelPreview.layer.borderColor = UIColor.black.cgColor
        
        // Add
        cell.addSubview(pixelPreview)
        
        return cell
    }
    
    // How this works
    // Goes through 1st position and adds to array
    // Then adds that array to 2nd array
    // Repeat for each position
    private func convertStringToCGPoint(_ points: [[String]]) -> [[CGPoint]] {

        var pointsD1: [CGPoint] = []
        var pointsD2: [[CGPoint]] = []
        
        for x in points {
            for y in x {
                pointsD1.append(CGPointFromString(y))
            }
            
            pointsD2.append(pointsD1)
            pointsD1.removeAll()
        }
        
        return pointsD2
    }
    
    private func convertIntToColor(_ colors: [[Int]]) -> [[UIColor]] {
        
        var colorsD1: [UIColor] = []
        var colorsD2: [[UIColor]] = []
        
        for x in colors {
            for y in x {
                colorsD1.append(UIColor.init(rgb: y))
            }
            
            colorsD2.append(colorsD1)
            colorsD1.removeAll()
        }
        
        return colorsD2
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
            AnimationDataset.deleteEntry(atIndex: indexPath.row)
            // Update table
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    // GO TO EDIT
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < AnimationDataset.count else {
            return
        }
        // Get values
        let pixelViewController = ProgressOfflineAnimationViewController(withIndex: indexPath.row)
        
        let pixelData = AnimationDataset.entry(atIndex: indexPath.row)

        let colors = convertIntToColor(pixelData.pixelColors)
        let positions = convertStringToCGPoint(pixelData.pixelPositions)
        
        // Set
        pixelViewController.pagePositions = positions
        pixelViewController.pageColors = colors
        pixelViewController.positions = positions[0]
        pixelViewController.colors = colors[0]
        
        navigationController?.pushViewController(pixelViewController, animated: true)
    }
}
