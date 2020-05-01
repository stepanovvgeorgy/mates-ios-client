//
//  UserViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 30.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

enum UserSections: Int, CaseIterable {
    case buttons = 0
    case links = 1
    case actions = 2
}

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userID: Int?
    var user: User?
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.indicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.isHidden = true
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.centerInView(view)
        
        getUser()
    }
    
    func getUser() {
        if let userID = userID {
            NetworkManager.shared.getUserById(userID) { (user) in
                self.user = user
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }

}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == UserSections.buttons.rawValue {
            return 0
        }
        
        if section == UserSections.links.rawValue {
            return 3
        }
        
        if section == UserSections.actions.rawValue {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let linkCell = tableView.dequeueReusableCell(withIdentifier: "LinkCell") as! LinkTableViewCell
        let actionCell = tableView.dequeueReusableCell(withIdentifier: "ActionCell") as! ActionTableViewCell
                
        if indexPath.section == UserSections.links.rawValue && indexPath.row == 0 {
            linkCell.iconImageView.image = #imageLiteral(resourceName: "home")
            linkCell.nameLabel.text = "Объявления"
        }
        
        if indexPath.section == UserSections.links.rawValue && indexPath.row == 1 {
            linkCell.iconImageView.image = #imageLiteral(resourceName: "loupe")
            linkCell.nameLabel.text = "Быстрые объявления"
        }
        
        if indexPath.section == UserSections.links.rawValue && indexPath.row == 2 {
            linkCell.iconImageView.image = #imageLiteral(resourceName: "contact")
            linkCell.nameLabel.text = "Отзывы"
        }
    
        if indexPath.section == UserSections.actions.rawValue && indexPath.row == 0 {
            actionCell.actionLabel.text = "Пожаловаться"
            return actionCell
        }
            
        return linkCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == UserSections.buttons.rawValue {
            
            let avatarCell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell") as! AvatarWithNameTableViewCell
            
            guard let avatarUrl = URL(string: user?.avatar ?? "") else {return avatarCell}
            
            avatarCell.avatarImageView.layer.cornerRadius = 45
            avatarCell.userNameLabel.text = "\(user?.first_name ?? "") \(user?.last_name ?? "")"
            avatarCell.bDateLabel.text = user?.b_date
            
            avatarCell.avatarImageView.sd_setImage(with: avatarUrl, placeholderImage: #imageLiteral(resourceName: "user-circle")) { (image, error, chache, url) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
            
            return avatarCell
            
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == UserSections.buttons.rawValue {
            let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell") as! ButtonsTableViewCell
            
            buttonsCell.callButton.layer.cornerRadius = 20
            buttonsCell.callButton.layer.borderWidth = 1
            buttonsCell.callButton.layer.borderColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
            buttonsCell.msgButton.layer.cornerRadius = 20
            
            return buttonsCell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == UserSections.buttons.rawValue {
            return 180
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == UserSections.buttons.rawValue {
            return 50
        }
        return 0
    }
}
