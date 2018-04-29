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
        self.navigationItem.rightBarButtonItem = newGameButton
        self.navigationItem.leftBarButtonItem = refreshListButton
        
    }
    
    // Create button
    lazy var newGameButton : UIBarButtonItem = {
        let newGameButton = UIBarButtonItem()
        newGameButton.title = "+"
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        var styles: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue): style]
        styles[NSAttributedStringKey.font] = UIFont(name: "DINCondensed-Bold", size: 40 )
        
        // set string
        let zone:String = "Days"
        
        // Create and draw
        newGameButton.setTitleTextAttributes(styles, for: UIControlState.normal)
        newGameButton.action = #selector(goToAlarmView)
        newGameButton.target = self
        return newGameButton
    }()
    
    // Refresh table if buggy
    lazy var refreshListButton : UIBarButtonItem = {
        let refreshListButton = UIBarButtonItem()
        refreshListButton.image = UIImage(named: "refresh_icon")
        
        refreshListButton.action = #selector(updateTable)
        refreshListButton.target = self
        refreshListButton.style = .plain
        return refreshListButton
    }()
    
    @objc func updateTable(sender: UIButton) {
        datasetUpdated()
    }
    
    // Go to new alarm
    @objc func goToAlarmView(sender: UIBarButtonItem) {
        
        //navigationController?.pushViewController(NewGameViewController(), animated: true)
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
        
        //Add text
        let pixelData = PixelDataset.entry(atIndex: indexPath.row)
        //cell.textLabel?.text = String(pixelData.pixelColors.first!)
        
        // Add preview
        let pixelPreview = PixelPreview()
        //pixelPreview.frame = CGRect(x: 5, y: 5, width: 100, height: 200)
        pixelPreview.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width/2, height: self.tableView.frame.height/2 )
        pixelPreview.colorsToDraw = convertIntToColor(pixelData.pixelColors)
        pixelPreview.positionsToDraw = convertStringToCGPoint(pixelData.pixelPositions)
        pixelPreview.backgroundColor = UIColor.white
        pixelPreview.layer.borderWidth = 1
        pixelPreview.layer.borderColor = UIColor.black.cgColor
        
        //cell.accessoryView = pixelPreview
        cell.addSubview(pixelPreview)

        return cell
    }
    
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
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < PixelDataset.count else {
            return
        }
        
        //navigationController?.pushViewController(ProgressViewController(withIndex: indexPath.row), animated: true)
        let pixelViewController = ProgressPixelViewController(withIndex: indexPath.row)
        
        let pixelData = PixelDataset.entry(atIndex: indexPath.row)
        //cell.textLabel?.text = String(pixelData.pixelColors.first!)
        pixelViewController.colors = convertIntToColor(pixelData.pixelColors)
        pixelViewController.positions = convertStringToCGPoint(pixelData.pixelPositions)
  
        navigationController?.pushViewController(pixelViewController, animated: true)
    }
}
