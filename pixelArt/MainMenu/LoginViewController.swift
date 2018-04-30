//
//  LoginViewController.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/28/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FBSDKLoginKit


class LoginViewController: UIViewController, LoginViewDelegate, LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("user did not login error")
                return
            }
            print("user is signed in")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {

        let auth = Auth.auth()
        do {
            try auth.signOut()
            print("user signed out of firebase and facebook")
        } catch let error as NSError {
            print(error)
        }

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("user did not login error")
                return
            }
            print("user is signed in")
        }
    }
    
    func loginButtonPressed(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error)
                self.showWarning("Unable to log in. Invalid Email or Password. Please try again.")
                return
            }
         self.navigationController?.popViewController(animated: true)
            print("Did signup and create user")
        }
    }
    
    func signupButtonPressed(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error)
                self.showWarning("Unable to create account. Invalid Email or Password. Please try again.")
                return
            }
            
            print("Did signup and create user")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showWarning(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var viewHolder: LoginView {
        return view as! LoginView
    }
    
    // Loads the view
    override func loadView() {
        
        view = LoginView(frame: UIScreen.main.bounds)

        print("loaded loginView")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.delegate = self
        viewHolder.facebookButton.delegate = self
    }
    
}
