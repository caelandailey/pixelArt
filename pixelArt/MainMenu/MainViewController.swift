//
//  MainViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth

@objc
protocol MainViewControllerDelegate {
    @objc optional func toggleMenu()
}

class MainViewController: UIViewController, MainViewDelegate {
    
     var delegate: MainViewControllerDelegate?
    
    private var viewHolder: MainView {
        return view as! MainView
    }
    
    // Loads the view
    override func loadView() {
        view = MainView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        print("Detail view load")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.delegate = self
        let asked = UserDefaults.standard.bool(forKey: "askedToLogin")
        
        if (Auth.auth().currentUser != nil && asked != true) {
            UserDefaults.standard.set(true, forKey: "askedToLogin")
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
    
    // Main open world
    func goToWorld() {
        print("pushing world viewcontroller")
        navigationController?.pushViewController(PixelViewController(), animated: true)
    }
    
    // Create new drawing offline
    func goToNewDrawing() {
        print("pushing new drawing")
        navigationController?.pushViewController(NewPixelViewController(), animated: true)
    }
    
    // Create an animation offline
    func goToAnimation() {
      
        navigationController?.pushViewController(OfflineAnimationViewController(), animated: true)
    }
  
}
