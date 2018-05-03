//
//  DrawingsTableViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/22/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class DrawingsTableViewController: UITableViewController, PixelDatasetDelegate {
    
    private static var cellReuseIdentifier = "DrawingsTableViewController.DatasetItemsCellIdentifier"
    
    let delegateID: String = UIDevice.current.identifierForVendor!.uuidString

    // Update on main thread
    func datasetUpdated() {
        DispatchQueue.main.async(){
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        datasetUpdated()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PixelDataset.registerDelegate(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DrawingsTableViewController.cellReuseIdentifier)
    }

    @objc func updateTable(sender: UIButton) {
        datasetUpdated()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == self.tableView, section == 0 else {
            return 0
        }
        return PixelDataset.count
    }
    
    // THIS CREATES THE CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < PixelDataset.count else {
            return UITableViewCell()
        }
        let cell: UITableViewCell = UITableViewCell()
        
        cell.backgroundColor = UIColor.groupTableViewBackground
        
        //Add data
        let pixelData = PixelDataset.entry(atIndex: indexPath.row)
        
        // Add preview
        let pixelPreview = PixelPreview()
        
        // Set frame
        pixelPreview.frame = CGRect(x: 0,
                                    y: 0,
                                    width: self.tableView.frame.width,
                                    height: self.tableView.frame.height )
        
        // Convert
        pixelPreview.colorsToDraw = convertIntToColor(pixelData.pixelColors)
        pixelPreview.positionsToDraw = convertStringToCGPoint(pixelData.pixelPositions)
        
        // Make it look pretty
        pixelPreview.backgroundColor = UIColor.white
        pixelPreview.layer.borderWidth = 1
        pixelPreview.layer.borderColor = UIColor.black.cgColor
        
        // Add
        cell.addSubview(pixelPreview)

        return cell
    }
    
    // Convert string array to cgpoint array
    // Needed because dataset is stored as string
    private func convertStringToCGPoint(_ points: [String]) -> [CGPoint] {
        var newPoints: [CGPoint] = []
        
        for p in points {
            newPoints.append(CGPointFromString(p))
        }
        return newPoints
    }
    
    // Convert int array to color array
    // Needed because the dataset is stored as int
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
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < PixelDataset.count else {
            return
        }

        // Get view
        let pixelViewController = ProgressPixelViewController(withIndex: indexPath.row)
        
        // Get data
        let pixelData = PixelDataset.entry(atIndex: indexPath.row)

        // Set data in view
        pixelViewController.colors = convertIntToColor(pixelData.pixelColors)
        pixelViewController.positions = convertStringToCGPoint(pixelData.pixelPositions)
  
        // Push view
        navigationController?.pushViewController(pixelViewController, animated: true)
    }
}
