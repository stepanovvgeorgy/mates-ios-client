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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func actionAdd(_ sender: UIBarButtonItem) {
        
        let addMateNavController = storyboard?.instantiateViewController(withIdentifier: "AddMateNavController")
        
        present(addMateNavController!, animated: true, completion: nil)
        
    }
    
}


extension MatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MateCell", for: indexPath) as! MateTableViewCell
        return cell
    }
    
    
}
