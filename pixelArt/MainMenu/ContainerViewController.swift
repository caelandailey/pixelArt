//
//  ContainerViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/22/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth
import QuartzCore

// This class is used for creating the slidable menu view on the mainviewcontroller
// Is also the destination for the Menuview delegate
class ContainerViewController: UIViewController, MainViewControllerDelegate, MenuViewDelegate {
    
    var menuViewController: MenuViewController?
    var mainNavigationController: UINavigationController!
    var mainViewController: MainViewController!
    var menuClosed = true
    
    func goToDrawings() {
        mainNavigationController.pushViewController(DrawingsTabBarController(), animated: true)
        animateMenuHandler()
    }
    
    func goToAnimations() {
        //mainNavigationController.pushViewController(AnimationTableViewController(), animated: true)
        mainNavigationController.pushViewController(AnimationsTabBarController(), animated: true)
        animateMenuHandler()
    }
    
    // Logout of account
    func logout() {
        
        let auth = Auth.auth()
        if (auth.currentUser != nil) {
            
            do {
                try auth.signOut()
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                
                animateMenuHandler()
                print("user signed out of firebase and facebook")
            } catch let error as NSError {
                print(error)
            }
        }
        animateMenuHandler()
        mainNavigationController.pushViewController(LoginViewController(), animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewController = MainViewController()
        mainViewController.delegate = self
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: .done, target: self, action: #selector(toggleMenu))
        menuButton.width = 40
        mainViewController.navigationItem.backBarButtonItem = nil
        mainViewController.navigationItem.setLeftBarButton(menuButton, animated: true)
        mainViewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        mainViewController.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 5, left: -35, bottom: 0, right: 0)
        mainNavigationController = MainNavigationController(rootViewController: mainViewController)
        view.addSubview(mainNavigationController.view)
        addChildViewController(mainNavigationController)
        
        mainNavigationController.didMove(toParentViewController: self)
    
    }
    
    func toggleMenu() {
        
        if menuClosed {
            addMenuViewController()
        }
        animateMenuHandler()
    }
    
    func addMenuViewController() {
        print("adding menuView")
        guard menuViewController == nil else {
            print("returning")
            return }
        
        let vc = MenuViewController()
        
        addMenuViewController(vc)
        menuViewController = vc
        menuViewController?.viewHolder.delegate = self
        menuViewController?.view.layer.shadowOpacity = 0.8
    }
    
    func addMenuViewController(_ menuController: MenuViewController) {
        // Insert above main menu
        view.insertSubview(menuController.view, at: 1)
        
        // Set position
        menuController.view.frame.origin.x = -self.view.frame.width
        
        // Add
        addChildViewController(menuController)

        menuController.didMove(toParentViewController: self)
    }
    
    private func animateMenuHandler() {
        if menuClosed {
            menuClosed = false
            animateMenu(pos: -self.view.frame.width * 2/3)
        } else {
            animateMenu(pos: -self.view.frame.width) { finished in
                self.menuClosed = true
                self.menuViewController?.view.removeFromSuperview()
                self.menuViewController = nil
            }
        }
    }
    
    private func animateMenu(pos: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
                        self.menuViewController?.view.frame.origin.x = pos
            
        }, completion: completion)
    }
    
    // Close the menu if user touches outside of menu
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!menuClosed) {
            toggleMenu()
        }
    }
}
