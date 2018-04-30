//
//  OnlineDrawingsTableViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/25/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

//
//  DrawingsTableViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/22/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class OnlineDrawingsTableViewController: UITableViewController, PixelDatasetDelegate {
    
    private static var cellReuseIdentifier = "OnlineDrawingsTableViewController.DatasetItemsCellIdentifier"
    
    let delegateID: String = UIDevice.current.identifierForVendor!.uuidString
    
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
        
        PixelDataset.registerDelegate(self)        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: OnlineDrawingsTableViewController.cellReuseIdentifier)
        self.navigationItem.rightBarButtonItem = newGameButton
        self.navigationItem.leftBarButtonItem = refreshListButton
        self.title = "Online"
    }
    
    private func loadData() {
        
        drawingsColor.removeAll()
        drawingsPosition.removeAll()
        
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("\(id)")
        
        ref.observe(.value, with: { snapshot in
            print("loading new pixel")
            self.count = Int(snapshot.childrenCount)
           
       
            for child in snapshot.children {
                var snap = child as! DataSnapshot
                self.drawingsRef.append(snap.key)
                snap = snap.childSnapshot(forPath: "Pixels")
                
                
                let enumerator = snap.children
                var colors: [UIColor] = []
                var positions: [CGPoint] = []
                
                for cells in enumerator.allObjects as! [DataSnapshot] {
                    //print(cell)
                    
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
                
                
                self.drawingsColor.append(colors)
                self.drawingsPosition.append(positions)
                
            }

        })
        print("finished loading data")

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
        
        return count
    }
    
    // THIS CREATES THE CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < PixelDataset.count else {
            return UITableViewCell()
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
        let vc: OnlinePixelViewController = OnlinePixelViewController(withRef: drawingsRef[indexPath.row])
        //vc.pixel.colors = drawingsColor[indexPath.row]
        //vc.pixel.positions = drawingsPosition[indexPath.row]
        vc.pixel.loadNewPixels()
        
        navigationController?.pushViewController(vc, animated: true)
    }

}
