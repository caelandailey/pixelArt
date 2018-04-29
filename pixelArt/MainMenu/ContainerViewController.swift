//
//  ContainerViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/22/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.

import UIKit

import QuartzCore

class ContainerViewController: UIViewController, MainViewControllerDelegate, MenuViewDelegate {
    
    func goToDrawings() {
        //mainNavigationController.pushViewController(DrawingsTableViewController(), animated: true)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = UIColor.white
        
        let onlineDrawingsTableViewController = OnlineDrawingsTableViewController()
        let drawingsTableViewController = DrawingsTableViewController()
        drawingsTableViewController.title = "Offline"
        tabBarController.viewControllers = [onlineDrawingsTableViewController, drawingsTableViewController]
        tabBarController.selectedViewController = onlineDrawingsTableViewController
        
        mainNavigationController.pushViewController(tabBarController, animated: true)
        animateMenuHandler()
    }
    
    var menuViewController: MenuViewController?
    var mainNavigationController: UINavigationController!
    var mainViewController: MainViewController!
    var menuClosed = true
    
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
        //mainNavigationController = UINavigationController(rootViewController: mainViewController)
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
        // Set origin
        menuController.view.frame.origin.x = -self.view.frame.width
        // Add it
        addChildViewController(menuController)
        // "It is expected that a container view
        //controller subclass will make this call after a transition to the new child has completed or, in the
        //case of no transition, immediately after the call to addChildViewController:"
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!menuClosed) {
            toggleMenu()
        }
    }
}
