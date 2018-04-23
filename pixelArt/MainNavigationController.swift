//
//  MainNavigationController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

// NOT CURRENTLY USED!???
class MainNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
      
    }
    
    // Required?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
