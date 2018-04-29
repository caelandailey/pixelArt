//
//  LoginViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/28/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var viewHolder: LoginView {
        return view as! LoginView
    }
    
    // Loads the view
    override func loadView() {
        
        view = MenuView(frame: UIScreen.main.bounds)

        print("loaded loginView")

    }
    
}
