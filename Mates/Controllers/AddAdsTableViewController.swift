//
//  AddAdsTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 02.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class AddAdsTableViewController: UITableViewController {
    
    @IBOutlet weak var addImagesButton: UIButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        addImagesButton.layer.cornerRadius = 20
        
        imagePicker.delegate = self
    }
    
    
    @IBAction func actionClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAddimages(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AddAdsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
