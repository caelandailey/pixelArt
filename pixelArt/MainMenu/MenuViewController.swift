//
//  MenuViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/22/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController{
    

    var viewHolder: MenuView {
        return view as! MenuView
    }
    
    // Loads the view
    override func loadView() {
       
        view = MenuView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.8
        print("load MenuViewController")
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
    }
}
