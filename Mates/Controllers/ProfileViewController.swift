//
//  ProfileTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 02.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        getUser()
    }
    
    func getUser() {
        let currentUserID = UserDefaults.standard.value(forKey: "user_id") as! Int
        NetworkManager.getUserById(currentUserID) { (user) in
            self.user = user
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    
    @IBAction func actionEdit(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func actionLogout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Выход", message: "Вы действительно хотите выйти?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Да", style: .default) { (action) in

        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            
        }
    }
    
    func logout() {

    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 0 {
                        
            cell.textLabel!.text = "Имя"
            cell.detailTextLabel!.text = user?.first_name
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            cell.textLabel!.text = "Фамилия"
            cell.detailTextLabel!.text = user?.last_name
        } else if indexPath.section == 0 && indexPath.row == 2 {
            cell.textLabel!.text = "Дата рождения"
            cell.detailTextLabel!.text = user?.b_date
        } else if indexPath.section == 0 && indexPath.row == 3 {
            cell.textLabel!.text = "Пол"
            if user?.gender == 0 {
                cell.detailTextLabel!.text = "Жен."
            } else {
                cell.detailTextLabel!.text = "Муж."
            }
        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell.textLabel!.text = "Email"
            cell.detailTextLabel!.text = user?.email
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.textLabel!.text = "Телефон"
            cell.detailTextLabel!.text = user?.phone
        }
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Личная информация"
        } else if section == 1 {
            return "Контактная информация"
        }
        return nil
    }
}

