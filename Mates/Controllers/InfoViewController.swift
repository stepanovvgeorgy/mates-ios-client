//
//  InfoViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 27.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func actionBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else if section == 1 {
            return 2
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.textLabel?.text = "Политика конфиденциальности"
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.textLabel?.text = "Связаться с нами"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let appCell = tableView.dequeueReusableCell(withIdentifier: "AppCell") as! AppTableViewCell
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
            
            appCell.nameLabel.text = "Mates \(appVersion)"
            appCell.buildLabel.text = "Сборка \(buildVersion)"
            
            appCell.logoImageView.layer.cornerRadius = 16
            appCell.logoImageView.clipsToBounds = true
            
            return appCell
            
        }
        
        return nil
    }
    
    
}
