//
//  AdsViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 01.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class AdsViewController: UIViewController {

    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let addAdsVC = storyboard?.instantiateViewController(withIdentifier: "AddAdsNavController")
        present(addAdsVC!, animated: true, completion: nil)
    }
}

extension AdsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! AdsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let adVC = storyboard?.instantiateViewController(withIdentifier: "AdTableViewController")
        
        navigationController?.pushViewController(adVC!, animated: true)
    }
}
