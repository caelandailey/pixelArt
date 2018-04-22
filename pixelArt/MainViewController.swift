//
//  MainViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, MainViewDelegate {
    
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
    }
    
    func goToWorld() {
        print("pushing world viewcontroller")
        navigationController?.pushViewController(PixelViewController(), animated: true)
    }
    
    func goToNewDrawing() {
        print("pushing new drawing")
        navigationController?.pushViewController(NewPixelViewController(), animated: true)
    }

  
}
