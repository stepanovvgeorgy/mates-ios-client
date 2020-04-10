//
//  ViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 29.03.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInViewController: UIViewController {
    
    // MARK: - PROPERTIES -
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waveImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        activityIndicator.stopAnimating()
        
        signInButton.layer.cornerRadius = 25
        
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.borderWidth = 1.5
        signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        emailTextField.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        emailTextField.layer.cornerRadius = 2
        emailTextField.setIcon(#imageLiteral(resourceName: "user"))
        
        passwordTextField.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        passwordTextField.layer.cornerRadius = 2
        passwordTextField.setIcon(#imageLiteral(resourceName: "lock"))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - METHODS  -
    
    @objc func keyboardWillShow() {
        UIView.animate(withDuration: 5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.bannerHeightConstraint.constant = 100
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.bannerHeightConstraint.constant = 220
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func signIn() {
        
        if (emailTextField.text != "" && passwordTextField.text != "") {
            activityIndicator.startAnimating()
            
            
            NetworkManager.shared.signIn(urlString: "/user/signin",
                                  email: emailTextField.text,
                                  password: passwordTextField.text) { (data) in
                                    
                                    
                                    let jsonData = JSON(data)
                                    
                                    UserDefaults.standard.set(jsonData["token"].stringValue, forKey: "token")
                                    UserDefaults.standard.set(jsonData["user_id"].intValue, forKey: "user_id")
                                    
                                    self.activityIndicator.stopAnimating()
                                    
                                    let innerVC = self.storyboard?.instantiateViewController(withIdentifier: "InnerTabBarController")
                                    
                                    innerVC?.modalPresentationStyle = .fullScreen
                                    
                                    self.present(innerVC!, animated: true, completion: nil)
            }
        } else {
            
        }
    
    }
    
    // MARK: - ACTIONS -
    
    @IBAction func actionSignIn(_ sender: UIButton) {
        self.signIn()
    }
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpTableViewController")
        present(signUpVC!, animated: true, completion: nil)
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(emailTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
            self.signIn()
        }
        
        return true
    }
    
}



