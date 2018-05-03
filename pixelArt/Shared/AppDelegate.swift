//
//  AppDelegate.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/9/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
// How it works.
/*
 Main View
 - Open Menu
 - Go to world
 - Create drawings
 - Create animations
 
 Firebase
 - This app using firebase to store online information and handle users
 
 Pods
 -Firebase
 -Facebook
 - For some reason they pop up a warning, pods are updated and these wont go away.
 
 Menu
 - Sliding out animation
 - Go to drawings
 - Go to animations
 - Has profile image
 - Has profile name
 - Go to login
 
 Login
 - Log into facebook
 - Log into email/password
 
 Shared features
 - Player count
 - Color control
 
 World
 - Represents 800x1220 pixel world
 - Zoom in
 - Online

 Drawings
 - Can draw online
 - Can draw offline
 - Saves offline drawings
 - Loads these into a tableview
 - Tableview has preview
 - Can eddit drawings
 
 Animations
 - Same as drawings, but is animation
 - Extra control to change frames
 
 */

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        // Configure database
        FirebaseApp.configure()

        let containerViewController = ContainerViewController()
        
        window!.rootViewController = containerViewController
        window?.makeKeyAndVisible()
    
        //return true
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }



    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

