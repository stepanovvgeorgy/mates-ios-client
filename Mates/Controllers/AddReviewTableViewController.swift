//
//  AddReviewTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 18.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class AddReviewTableViewController: UITableViewController {
    
    @IBOutlet weak var finishedTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var starsSegmentControl: UISegmentedControl!
    
    fileprivate var selectedStarIndex: Int = 1
    
    var pickerView: UIPickerView = UIPickerView()
    
    var toUserID: Int?
    
    let results = ["Сделка состоялась", "Сделка сорвалась", "Не удалось связаться"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTextView.text = "Ваш отзыв..."
        reviewTextView.textColor = .lightGray
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        finishedTextField.inputView = pickerView
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func actionClose(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSendReview(_ sender: UIBarButtonItem) {
        if !finishedTextField.text!.isEmpty &&
            !reviewTextView.text.isEmpty {
            
            if let toUserID = toUserID {
                let review = Review(star: selectedStarIndex, text: reviewTextView.text, result: finishedTextField.text, toUserID: nil, userID: nil, authorFirstName: nil, authorLastName: nil, authorAvatarUrl: nil)
                
                NetworkManager.shared.sendReview(toUserID: toUserID, review: review) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reviewDidSend"), object: nil)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            present(Helper.shared.showInfoAlert(title: "Ошибка", message: "Заполните все поля")!, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionChangeStars(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 0)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 1)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 2)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 3)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 4)
            selectedStarIndex = 1
        case 1:
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 0)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 1)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 2)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 3)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 4)
            selectedStarIndex = 2
        case 2:
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 0)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 1)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 2)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 3)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 4)
            selectedStarIndex = 3
        case 3:
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 0)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 1)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 2)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 3)
            sender.setImage(#imageLiteral(resourceName: "star-empty"), forSegmentAt: 4)
            selectedStarIndex = 4
        case 4:
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 0)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 1)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 2)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 3)
            sender.setImage(#imageLiteral(resourceName: "star-gold"), forSegmentAt: 4)
            selectedStarIndex = 5
        default:
            break
        }
        
    }
}

extension AddReviewTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return results.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return results[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finishedTextField.text = results[row]
    }
}

extension AddReviewTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(finishedTextField) {
            finishedTextField.text = results[0]
        }
    }
}

extension AddReviewTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ваш отзыв..."
            textView.textColor = UIColor.lightGray
        }
    }
}
