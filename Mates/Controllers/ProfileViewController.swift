//
//  ProfileTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 02.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit
import SDWebImage

enum ProfileSections: Int, CaseIterable {
    case avatar = 0
    case info = 1
    case contacts = 2
    case links = 3
    case actions = 4
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView.indicator
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
        
    var user: User?
    
    var imageFromPicker: UIImage? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.contentInset = UIEdgeInsets(top: 20, left:0, bottom: 20, right: 0)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        view.addSubview(activityIndicator)
        
        activityIndicator.centerInView(view)
        
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
    
    func logout() {
        
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
            self.imageFromPicker = image
            picker.dismiss(animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == ProfileSections.avatar.rawValue {
            return 0
        }
        
        if section == ProfileSections.info.rawValue {
            return 4
        }
        
        if section == ProfileSections.contacts.rawValue {
            return 2
        }
        
        if section == ProfileSections.links.rawValue {
            return 3
        }
        
        if section == ProfileSections.actions.rawValue {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell") as! UserInfoTableViewCell
        
        cell.selectionStyle = .none
        
        let linkCell = tableView.dequeueReusableCell(withIdentifier: "LinkCell") as! LinkTableViewCell
        
        let actionCell = tableView.dequeueReusableCell(withIdentifier: "ActionCell") as! ActionTableViewCell
        
        if indexPath.section == ProfileSections.info.rawValue && indexPath.row == 0 {
            
            cell.titleLabel!.text = "Имя"
            cell.valueLabel!.text = user?.first_name
            
        } else if indexPath.section == ProfileSections.info.rawValue && indexPath.row == 1 {
            
            cell.titleLabel!.text = "Фамилия"
            cell.valueLabel!.text = user?.last_name
            
        } else if indexPath.section == ProfileSections.info.rawValue && indexPath.row == 2 {
            cell.titleLabel!.text = "Дата рождения"
            cell.valueLabel!.text = user?.b_date
            
        } else if indexPath.section == ProfileSections.info.rawValue && indexPath.row == 3 {
            
            cell.titleLabel!.text = "Пол"
            if user?.gender == 0 {
                cell.valueLabel!.text = "Жен."
            } else {
                cell.valueLabel!.text = "Муж."
            }
            
        } else if indexPath.section == ProfileSections.contacts.rawValue && indexPath.row == 0 {
            
            cell.titleLabel!.text = "Email"
            cell.valueLabel!.text = user?.email
            
        } else if indexPath.section == ProfileSections.contacts.rawValue && indexPath.row == 1 {
            
            cell.titleLabel!.text = "Телефон"
            cell.valueLabel!.text = user?.phone
            
        } else if indexPath.section == ProfileSections.links.rawValue && indexPath.row == 0 {
            
            linkCell.nameLabel.text = "Мои объявления"
            linkCell.iconImageView.image = #imageLiteral(resourceName: "home")

            return linkCell
            
        } else if indexPath.section == ProfileSections.links.rawValue && indexPath.row == 1 {
            
            linkCell.nameLabel.text = "Мои быстрые объявления"
            linkCell.iconImageView.image = #imageLiteral(resourceName: "loupe")

            return linkCell
            
        } else if indexPath.section == ProfileSections.links.rawValue && indexPath.row == 2 {
            
            linkCell.nameLabel.text = "Избранные объявления"
            linkCell.iconImageView.image = #imageLiteral(resourceName: "star-empty")

            return linkCell
            
        } else if indexPath.section == ProfileSections.actions.rawValue && indexPath.row == 0 {
            
            actionCell.actionLabel.text = "Выход"
            
            return actionCell
            
        }

        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == ProfileSections.links.rawValue && indexPath.row == 0 {
            
            let adsViewController = storyboard?.instantiateViewController(withIdentifier: "AdsViewController") as! AdsViewController
                        
            navigationController?.pushViewController(adsViewController, animated: true)
            
        }
        
        if indexPath.section == ProfileSections.links.rawValue && indexPath.row == 1 {
            
            let matesViewController = storyboard?.instantiateViewController(withIdentifier: "MatesViewController") as! MatesViewController
                        
            navigationController?.pushViewController(matesViewController, animated: true)
            
        }
        
        if indexPath.section == ProfileSections.actions.rawValue && indexPath.row == 0 {
            logout()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == ProfileSections.avatar.rawValue {
            
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
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(showPicker)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == ProfileSections.avatar.rawValue {
            return 100
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == ProfileSections.links.rawValue {
            return 56
        }
        
        if indexPath.section == ProfileSections.actions.rawValue {
            return 46
        }
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == ProfileSections.avatar.rawValue && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == ProfileSections.info.rawValue {
            return "Личная информация"
        } else if section == ProfileSections.contacts.rawValue {
            return "Контактная информация"
        }
        return nil
    }
}

