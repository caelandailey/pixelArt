//
//  AnimationsTabBarController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 5/2/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class AnimationsTabBarController: UITabBarController, UITabBarControllerDelegate{
    
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
        
        isOnlineVC = (viewController is AnimationTableViewController)
        
    }
    
    var isOnlineVC = true
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
    
    @objc func goToDrawing() {
        print("PRESS NEW DRAWING")
        if (isOnlineVC) {
            print("1111111111")
            navigationController?.pushViewController(OnlineAnimationViewController(withRef: ""), animated: true)
        } else {
            print("22222222222")
            navigationController?.pushViewController(OfflineAnimationViewController(), animated: true)
        }
        
    }
    
}
