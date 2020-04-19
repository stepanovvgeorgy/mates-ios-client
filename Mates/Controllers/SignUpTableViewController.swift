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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func bDateNextField(_ sender: UIBarButtonItem) {
        emailTextField.becomeFirstResponder()
    }
    
    @objc func setBDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        
        components.calendar = calendar
        components.year = -18
        
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        sender.maximumDate = maxDate
        bDateTextField.text = dateFormatter.string(from: sender.date)
    }

    func signUp() {
        if !firstNameTextFeild.text!.isEmpty &&
        !lastNameTextField.text!.isEmpty &&
        !bDateTextField.text!.isEmpty &&
        !emailTextField.text!.isEmpty &&
        !phoneTextField.text!.isEmpty &&
        !passwordTextField.text!.isEmpty &&
        !passwordRepeatTextField.text!.isEmpty {
            
            if passwordTextField.text! != passwordRepeatTextField.text! {
                let alert = Helper.shared.showInfoAlert(title: "Ошибка", message: "Пароли не совпадают")
                present(alert!, animated: true, completion: nil)
            } else {
                let user = User(first_name: firstNameTextFeild.text!,
                                last_name: lastNameTextField.text!,
                                b_date: bDateTextField.text!,
                                gender: genderSegmentControl.selectedSegmentIndex,
                                email: emailTextField.text!,
                                phone: phoneTextField.text!,
                                password: passwordTextField.text!,
                                avatar: nil)
                
                NetworkManager.shared.signUp(urlString: "/user/sign-up", user: user, { (data) in
                    
                       let jsonData = JSON(data)
                       
                       UserDefaults.standard.set(jsonData["token"].stringValue, forKey: "token")
                       UserDefaults.standard.set(jsonData["user_id"].intValue, forKey: "user_id")
                    
                       let innerVC = self.storyboard?.instantiateViewController(withIdentifier: "InnerTabBarController")
                       let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")

                       innerVC?.modalPresentationStyle = .fullScreen
                       
                    self.present(innerVC!, animated: true)
                    
                }) { (errors) in
                    let jsonErrors = JSON(errors)
                    
                    let infoAlert = Helper.shared.showInfoAlert(title: "Ошибка", message: jsonErrors["error"].stringValue)
                    
                    self.present(infoAlert!, animated: true, completion: nil)
                }
            }
        } else {
            let alert = Helper.shared.showInfoAlert(title: "Ошибка", message: "Заполните все поля")
            present(alert!, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        signUp()
    }
    
    @IBAction func actionSignIn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(bDateTextField) {
            setBDate(bDatePicker)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(firstNameTextFeild) {
            lastNameTextField.becomeFirstResponder()
        }
        if textField.isEqual(lastNameTextField) {
            bDateTextField.becomeFirstResponder()
        }
        if textField.isEqual(emailTextField) {
            phoneTextField.becomeFirstResponder()
        }
        if textField.isEqual(passwordTextField) {
            passwordRepeatTextField.becomeFirstResponder()
        }
        if textField.isEqual(passwordRepeatTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
