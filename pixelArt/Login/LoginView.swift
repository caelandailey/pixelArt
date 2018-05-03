//
//  LoginView.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/28/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth

protocol LoginViewDelegate: AnyObject {
    func loginButtonPressed(email: String, password: String)
    func signupButtonPressed(email: String, password: String)
}

class LoginView: UIView, UITextFieldDelegate {

    
    weak var delegate: LoginViewDelegate?
    
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Pixel"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 48)
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.largeTitle)
 
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Please log in or create an account"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        return descriptionLabel
    }()
    
    let usernameTextField: CustomTextField = {
        let usernameTextField = CustomTextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.backgroundColor = .white
        usernameTextField.layer.borderWidth = 1
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        
        usernameTextField.placeholderRect(forBounds: usernameTextField.bounds)

        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        return usernameTextField
    }()
    
    let passwordTextField: CustomTextField = {
        let passwordTextField = CustomTextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .white
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.none
        passwordTextField.placeholderRect(forBounds: passwordTextField.bounds)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
     
        return passwordTextField
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.reversesTitleShadowWhenHighlighted = true
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.layer.shadowOpacity = 0.4
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
       return loginButton
    }()
    
    let signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.backgroundColor = UIColor(red: 14/255, green: 125/255, blue: 255/255, alpha: 1.0)
        signupButton.layer.shadowOpacity = 0.4
        signupButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        return signupButton
    }()
    

    let facebookButton: LoginButton = {
        let facebookButton = LoginButton(readPermissions: [ .publicProfile ])
        return facebookButton
    }()
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        self.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1.0)
        print("creating loginview")
       
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(signupButton)
        addSubview(facebookButton)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        titleLabel.frame = CGRect(x: 0, y: self.bounds.height/10, width: self.bounds.width, height: self.bounds.height/10)
        descriptionLabel.frame = CGRect(x: self.bounds.width/5, y: titleLabel.frame.origin.y + titleLabel.frame.height, width: self.bounds.width*3/5, height: self.bounds.height/10)
        usernameTextField.frame = CGRect(x: 0, y: descriptionLabel.frame.origin.y+descriptionLabel.frame.height, width: self.bounds.width, height: self.bounds.height/10)
        passwordTextField.frame = CGRect(x: 0, y: usernameTextField.frame.origin.y+usernameTextField.frame.height, width: self.bounds.width, height: self.bounds.height/10)
        loginButton.frame = CGRect( x: 0, y: passwordTextField.frame.origin.y + passwordTextField.frame.height + self.bounds.height/20, width: self.bounds.width, height: self.bounds.height/10)
        signupButton.frame = CGRect(x: 0, y: loginButton.frame.origin.y + loginButton.frame.height + self.bounds.height/20, width: self.bounds.width, height: self.bounds.height/10)
        
        facebookButton.center = self.center
        facebookButton.frame.origin = CGPoint(x: facebookButton.frame.origin.x, y: signupButton.frame.origin.y + signupButton.frame.height + self.bounds.height/20)
        facebookButton.frame.size = CGSize(width: self.bounds.width, height: self.bounds.height/10)
        
    }
    
    @objc func loginButtonPressed() {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            delegate?.loginButtonPressed(email: username, password: password)
        }
        
    }
    
    @objc func signupButtonPressed() {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            delegate?.signupButtonPressed(email: username, password: password)
        }
    }
    
}
