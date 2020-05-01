//
//  MatesViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 21.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class MatesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView.indicator
    
    fileprivate var matesArray = Array<Mate>()
    fileprivate var pageNumber = 1
    fileprivate let limit = 10
    fileprivate var totalCount: Int?
    
    var currentUserID: Int {
        get {
            return UserDefaults.standard.value(forKey: "user_id") as! Int
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshVC(_:)), name: Notification.Name(rawValue: "sentMate"), object: nil)
        
        view.addSubview(activityIndicator)
        
        activityIndicator.centerInView(view)
        
        getMates()
    }
    
    func getMates() {
        activityIndicator.startAnimating()
        
        let url = "/mate/all?page=\(pageNumber)&limit=\(limit)"
        
        NetworkManager.shared.getMates(url: url) { (mates, totalCount) in
            self.totalCount = Int(totalCount)
            self.matesArray.append(contentsOf: mates)
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    @objc func refreshVC(_ notification: Notification?) {
       activityIndicator.startAnimating()
       pageNumber = 1
       matesArray = Array<Mate>()
       totalCount = 0
       getMates()
    }
    
    @IBAction func actionAdd(_ sender: UIBarButtonItem) {
        
        let addMateNavController = storyboard?.instantiateViewController(withIdentifier: "AddMateNavController")
        
        present(addMateNavController!, animated: true, completion: nil)
        
    }
    
}


extension MatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MateCell", for: indexPath) as! MateTableViewCell
        
        let mate = matesArray[indexPath.row]
        
        cell.userNameLabel.text = "\(mate.userFirstName!) \(mate.userLastName!)"
        
        if mate.userID == currentUserID {
            cell.actionButton.isHidden = true
        }
        
        switch mate.gender {
        case 0:
            cell.genderLabel.text = "Ищу соседку"
        case 1:
            cell.genderLabel.text = "Ищу соседа"
        case 2:
            cell.genderLabel.text = "Ищу соседку/соседа"
        default:
            break
        }
        
        
        cell.infoTextLabel.text = mate.infoText

        guard let avatarUrl = URL(string: mate.userAvatarUrl!) else {return cell}
        
        cell.avatarImageView.sd_setImage(with: avatarUrl, placeholderImage: #imageLiteral(resourceName: "user-circle")) { (image, error, cache, url) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mate = matesArray[indexPath.row]
        
        let userViewController = storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        
        userViewController.userID = mate.userID
        
        navigationController?.pushViewController(userViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == matesArray.count - 1 {
            if matesArray.count < totalCount! {
                pageNumber = pageNumber + 1
                getMates()
            } else {
                print("All mates loaded")
            }
        }
    }
    
}
