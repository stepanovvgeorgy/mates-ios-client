//
//  ProfileTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 02.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
        
    var user: User?
    
    var imageFromPicker: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.contentInset = UIEdgeInsets(top: 20, left:0, bottom: 20, right: 0)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        getUser()
    }
    
    func getUser() {
        let currentUserID = UserDefaults.standard.value(forKey: "user_id") as! Int
        NetworkManager.shared.getUserById(currentUserID) { (user) in
            self.user = user
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    
    @IBAction func actionLogout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Выход", message: "Выйти из аккаунта?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { (action) in
            Helper.shared.logout {
                let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")
                let innerTabBar = self.storyboard?.instantiateViewController(withIdentifier: "InnerTabBarController")
                signInVC?.modalPresentationStyle = .fullScreen
                self.present(signInVC!, animated: true) {
                    innerTabBar?.dismiss(animated: false, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        NetworkManager.shared.uploadImage(url: "/images/avatar", image, adID: nil, resize: CGSize(width: 120, height: 120)) {
            self.tableView.reloadData()
            self.imageFromPicker = image
            picker.dismiss(animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }
        
        if section == 1 {
            return 4
        }
        
        if section == 2 {
            return 2
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
            cell.textLabel!.text = "Имя"
            cell.detailTextLabel!.text = user?.first_name
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            
            cell.textLabel!.text = "Фамилия"
            cell.detailTextLabel!.text = user?.last_name
            
        } else if indexPath.section == 1 && indexPath.row == 2 {
            cell.textLabel!.text = "Дата рождения"
            cell.detailTextLabel!.text = user?.b_date
            
        } else if indexPath.section == 1 && indexPath.row == 3 {
            
            cell.textLabel!.text = "Пол"
            if user?.gender == 0 {
                cell.detailTextLabel!.text = "Жен."
            } else {
                cell.detailTextLabel!.text = "Муж."
            }
            
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
            cell.textLabel!.text = "Email"
            cell.detailTextLabel!.text = user?.email
            
        } else if indexPath.section == 2 && indexPath.row == 1 {
            
            cell.textLabel!.text = "Телефон"
            cell.detailTextLabel!.text = user?.phone
            
        }

        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let view = tableView.dequeueReusableCell(withIdentifier: "AvatarCell") as! AvatarTableViewCell
                        
            view.avatarImageView.layer.cornerRadius = 45
            view.avatarImageView.clipsToBounds = true
                        
            guard let avatarUrl = URL(string: user?.avatar ?? "") else {return view}

            if imageFromPicker == nil {
                
                view.avatarImageView.sd_setImage(with: avatarUrl, placeholderImage: #imageLiteral(resourceName: "user-circle"), options: .delayPlaceholder) { (image, error, cache, url) in
                    if error == nil {
                        view.avatarImageView.image = image
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                }
                
            } else {
                view.avatarImageView.image = imageFromPicker
            }

            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker(_:)))
            
            
            view.addGestureRecognizer(tapGesture)
            
            return view
        }
        
        return nil
        
    }
    
    @objc func presentImagePicker(_ sender: UIView) {
        
        let actionSheet = UIAlertController(title: "Фотография",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let showPicker = UIAlertAction(title: "Выбрать фотографию", style: .default) { (action) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(showPicker)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Личная информация"
        } else if section == 2 {
            return "Контактная информация"
        }
        return nil
    }
}

