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

class MainViewController: UIViewController, MainViewDelegate, LoginButtonDelegate {
    
     var delegate: MainViewControllerDelegate?
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {

        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("user did not login error")
                return
            }
            print("user is signed in")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    
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
        
        /*
        //creating button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        //adding it to view
        view.addSubview(loginButton)
        //view.addSubview(LoginView(frame: UIScreen.main.bounds))
        //self.navigationController?.isToolbarHidden = false
        
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
 */
    }
    
    var dict : [String : AnyObject]!
    
    func goToWorld() {
        print("pushing world viewcontroller")
        navigationController?.pushViewController(PixelViewController(), animated: true)
    }
    
    func goToNewDrawing() {
        print("pushing new drawing")
        //navigationController?.pushViewController(NewPixelViewController(), animated: true)
        navigationController?.pushViewController(OnlinePixelViewController(withRef: ""), animated: true)
    }
    
    func goToAnimation() {
        delegate?.toggleMenu?()
    }

    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                } else {
                    print("ERROR getting data")
                }
            })
        }
    }
  
}
