//
//  AnimationsTabBarController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/2/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit


// Tab bar for the animation tableviews
class AnimationsTabBarController: UITabBarController, UITabBarControllerDelegate{
    
    // Which viewcontroller were on variable
    var isOnlineVC = true
    
    override func viewDidLoad() {
        
        self.tabBar.barTintColor = UIColor.white
        delegate = self
        
        let onlineDrawingsTableViewController = AnimationTableViewController()
        let drawingsTableViewController = OfflineAnimationsTableViewController()
        
        drawingsTableViewController.title = "Offline"
        onlineDrawingsTableViewController.title = "Online"
        
        self.viewControllers = [onlineDrawingsTableViewController, drawingsTableViewController]
        self.selectedViewController = onlineDrawingsTableViewController
        
        self.navigationItem.rightBarButtonItem = newGameButton
    }
    
    // Handles which viewcontroller were currently looking at
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        isOnlineVC = (viewController is AnimationTableViewController)
    }
    
    // Create button
    lazy var newGameButton : UIBarButtonItem = {
        let newGameButton = UIBarButtonItem()
        newGameButton.title = "+"
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        var styles: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue): style]
        styles[NSAttributedStringKey.font] = UIFont(name: "DINCondensed-Bold", size: 40 )
        
        // Create and draw
        newGameButton.setTitleTextAttributes(styles, for: UIControlState.normal)
        
        newGameButton.action = #selector(goToDrawing)
        
        newGameButton.target = self
        return newGameButton
    }()
    
    // When we go to a drawing we want to go to the correct one
    @objc func goToDrawing() {
   
        if (isOnlineVC) {

            navigationController?.pushViewController(OnlineAnimationViewController(withRef: ""), animated: true)
        } else {
   
            navigationController?.pushViewController(OfflineAnimationViewController(), animated: true)
        }
        
    }
    
}
