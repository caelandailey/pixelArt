//
//  MainNavigationController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        
    }
    
    // Required?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Tab bar item
    let alarmListButton : UITabBarItem = {
        let alarmListButton = UITabBarItem()
        alarmListButton.title = "Alarms"
        alarmListButton.image = UIImage(named: "alarm_icon")
        
        return alarmListButton
    }()
    */
}
