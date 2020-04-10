//
//  SignUpTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 30.03.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var firstNameTextFeild: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var bDateTextField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var signUnBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet var signUpFields: [UITextField]!
    
    let bDatePicker = UIDatePicker()
    let bDateToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextFeild.setIcon(#imageLiteral(resourceName: "user-circle"))
        lastNameTextField.setIcon(#imageLiteral(resourceName: "user-circle"))
        bDateTextField.setIcon(#imageLiteral(resourceName: "calendar"))
        emailTextField.setIcon(#imageLiteral(resourceName: "email"))
        phoneTextField.setIcon(#imageLiteral(resourceName: "phone"))
        passwordTextField.setIcon(#imageLiteral(resourceName: "lock"))
        passwordRepeatTextField.setIcon(#imageLiteral(resourceName: "lock"))
        
        Helper.shared.styledNavigationBar(navigationController: navigationController,
                                   backgroundColor: #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1),
                                   textColor: .white,
                                   isTranslucent: true)
        
    
        bDatePicker.datePickerMode = .date
        bDatePicker.locale = Locale(identifier: "ru_RU")
        bDatePicker.addTarget(self, action: #selector(setBDate(_:)), for: .valueChanged)
        
        let bDateNextBarButton = UIBarButtonItem(title: "Далее", style: .done, target: self, action: #selector(bDateNextField(_:)))
        let bDateSpacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bDateNextBarButton.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        bDateToolbar.items = [bDateSpacerItem, bDateNextBarButton]
        
        bDateTextField.inputView = bDatePicker
        bDateTextField.inputAccessoryView = bDateToolbar
        
        signUpButton.layer.cornerRadius = 20
        
        navigationController?.navigationBar.tintColor = .white
        
        genderSegmentControl.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
    }
    
    @objc func bDateNextField(_ sender: UIBarButtonItem) {
        emailTextField.becomeFirstResponder()
    }
    
    @objc func setBDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        bDateTextField.text = dateFormatter.string(from: sender.date)
    }

    func signUp() {
        
        var allFieldsEmpty = true
        var passwordsEqual = false
        
        signUpFields.forEach { (textfield) in
            if textfield.text != "" {
                if signUpFields[5].text == signUpFields[6].text {
                    allFieldsEmpty = false
                    passwordsEqual = true
                }
                
            } else {
                present(Helper.shared.showInfoAlert(title: "Ошибка", message: "Заполните все поля")!,
                        animated: true,
                        completion: nil)
            }
        }
        
        if !passwordsEqual {
            present(Helper.shared.showInfoAlert(title: "Ошибка", message: "Пароли не совпадают")!,
                    animated: true,
                    completion: nil)
        }
        
        if !allFieldsEmpty {
            
            let user = User(first_name: firstNameTextFeild.text!,
                            last_name: lastNameTextField.text!,
                            b_date: bDateTextField.text!,
                            gender: genderSegmentControl.selectedSegmentIndex,
                            email: emailTextField.text!,
                            phone: phoneTextField.text!,
                            password: passwordTextField.text!)
            
            NetworkManager.shared.signUp(urlString: "/user/signup", user: user) { (data) in
                
                let jsonData = JSON(data)
                
                UserDefaults.standard.set(jsonData["token"].stringValue, forKey: "token")
                UserDefaults.standard.set(jsonData["user_id"].intValue, forKey: "user_id")
             
                let innerVC = self.storyboard?.instantiateViewController(withIdentifier: "InnerTabBarController")
                
                innerVC?.modalPresentationStyle = .fullScreen
                
                self.present(innerVC!, animated: true, completion: nil)
                
            }
        }
        
    }
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        signUp()
    }
    
    @IBAction func actionSignIn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

