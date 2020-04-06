//
//  AddAdsTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 02.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

let timeToSubwayList = [
    "5 минут",
    "10 минут",
    "15 минут",
    "20 минут",
    "25+ минут"
]


class AddAdsTableViewController: UITableViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var addImagesButton: UIButton!
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var subwayTextField: UITextField!
    @IBOutlet weak var animalsSwitch: UISwitch!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    @IBOutlet weak var genderMateCell: UITableViewCell!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var numberOfHouseTextField: UITextField!
    @IBOutlet weak var housingTextField: UITextField!
    @IBOutlet weak var numberOfRoomsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var salesNumberRoomsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderMateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var howLongSegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceTimeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timeToSubwayTextField: UITextField!
    @IBOutlet weak var genderMateLabel: UILabel!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var infoTextView: UITextView!
    
    var attachmentImages: [UIImage] = Array()
    var attachmentImagesInBase64: [String] = Array()
    
    let subwayPickerView = UIPickerView()
    let timeToSubwayPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        addImagesButton.layer.cornerRadius = 20
        
        subwayPickerView.dataSource = self
        subwayPickerView.delegate = self
        
        timeToSubwayPickerView.dataSource = self
        timeToSubwayPickerView.delegate = self
        
        infoTextView.layer.borderWidth = 1
        infoTextView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        infoTextView.layer.cornerRadius = 5
        infoTextView.backgroundColor = .white
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        timeToSubwayTextField.inputView = timeToSubwayPickerView
        
        subwayTextField.inputView = subwayPickerView
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        typeSegmentControl.tintColor = UIColor.lightGray
        numberOfRoomsSegmentedControl.tintColor = UIColor.lightGray
        salesNumberRoomsSegmentedControl.tintColor = UIColor.lightGray
        genderMateSegmentedControl.tintColor = UIColor.lightGray
        howLongSegmentedControl.tintColor = UIColor.lightGray
        priceTimeSegmentedControl.tintColor = UIColor.lightGray
        animalsSwitch.onTintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func actionChangeType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            genderMateLabel.text = "Кому сдам"
        }
    }
    
    @IBAction func actionPublish(_ sender: UIBarButtonItem) {
        uploadImages()
    }
        
    func uploadImages() {
        if !attachmentImages.isEmpty {
            for image in attachmentImages {
                NetworkManager.uploadImage(image) {
     
                }
            }
        }
    }
    
    @IBAction func actionClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAddimages(_ sender: UIButton) {
        if attachmentImages.count < 4 {
            present(imagePicker, animated: true, completion: nil)
        } else {
            present(Helper.showInfoAlert(title: "Ошибка", message: "Вы можете прикрепить не более четырех изображений")!, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return 65
        }
        
        if attachmentImages.count != 0 && indexPath.section == 2 && indexPath.row == 1 {
            return 110
        }
        
        if attachmentImages.count == 0 && indexPath.section == 2 && indexPath.row == 1 {
            return 0
        }
        
        if indexPath.section == 3 && indexPath.row == 4 {
            return 65
        }
        
        return 85
    }
    
}

extension AddAdsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.layer.cornerRadius = 5
        
        cell.photoImageView.image = attachmentImages[indexPath.row]
        
        return cell
        
    }
}

extension AddAdsTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.isEqual(subwayPickerView) {
            return StationsList.all.count
        }
        
        if pickerView.isEqual(timeToSubwayPickerView) {
            return timeToSubwayList.count
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.isEqual(subwayPickerView) {
            
            let station = StationsList.all[row]
            
            return station
            
        }
        
        if pickerView.isEqual(timeToSubwayPickerView) {
            let time = timeToSubwayList[row]
            
            return time
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.isEqual(subwayPickerView) {
            subwayTextField.text = StationsList.all[row]
        }
        if pickerView.isEqual(timeToSubwayPickerView) {
            timeToSubwayTextField.text = timeToSubwayList[row]
        }
    }
    
}

extension AddAdsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        attachmentImages.append(image)
        
        self.imagesCollectionView.reloadData()
        self.tableView.reloadData()
        
        picker.dismiss(animated: true)
    }
    
    
}
