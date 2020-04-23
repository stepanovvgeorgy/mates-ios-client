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
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    var districtPickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
        infoTextView.backgroundColor = .white
        districtTextField.inputView = districtPickerView
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
        
        if !districtTextField.text!.isEmpty
            && !infoTextView.text!.isEmpty {
            print("send")
        } else {
            let alert = Helper.shared.showInfoAlert(title: "Ошибка", message: "Заполните все поля")
            present(alert!, animated: true, completion: nil)
        }
        
    }
}

extension AddMateTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(districtTextField) {
            districtTextField.text = CityInfo.districts[0]
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
        return CityInfo.districts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CityInfo.districts[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        districtTextField.text = CityInfo.districts[row]
    }
    
}
