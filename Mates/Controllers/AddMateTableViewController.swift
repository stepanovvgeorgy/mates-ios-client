//
//  AddMateTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 21.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class AddMateTableViewController: UITableViewController {

    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var subwayTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    var subwayPickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subwayPickerView.delegate = self
        subwayPickerView.dataSource = self
        infoTextView.backgroundColor = .white
        subwayTextField.inputView = subwayPickerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func actionClose(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSend(_ sender: UIBarButtonItem) {
        
        if !subwayTextField.text!.isEmpty
            && !infoTextView.text!.isEmpty {

            sendMate()
            
        } else {
            let alert = Helper.shared.showInfoAlert(title: "Ошибка", message: "Заполните все поля")
            present(alert!, animated: true, completion: nil)
        }
        
    }
    
    func sendMate() {
        let mate = Mate(gender: genderSegmentControl.selectedSegmentIndex,
                        subway: subwayTextField.text!,
                        infoText: infoTextView.text!,
                        userFirstName: nil,
                        userLastName: nil,
                        userAvatarUrl: nil,
                        userID: nil)
        
        NetworkManager.shared.sendMate(mate) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "sendedMate"), object: nil)

            let alert = UIAlertController(title: "", message: "Объявление успешно добавлено", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ок", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
            
        }
    }
}

extension AddMateTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(subwayTextField) {
            subwayTextField.text = CityInfo.subwayStations[0]
        }
    }
}

extension AddMateTableViewController: UITextViewDelegate {
    
}

extension AddMateTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CityInfo.subwayStations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CityInfo.subwayStations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subwayTextField.text = CityInfo.subwayStations[row]
    }
    
}
