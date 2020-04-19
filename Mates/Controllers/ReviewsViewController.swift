//
//  ReviewsViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 18.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addReviewButton: UIButton!
    
    var toUserID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        addReviewButton.layer.cornerRadius = 22
        
        let currentUserID = UserDefaults.standard.value(forKey: "user_id") as! Int
        
        if toUserID == currentUserID {
            addReviewButton.isHidden = true
        }
        
    }
    
    @IBAction func actionAddReview(_ sender: UIButton) {
        
        if let toUserID = toUserID {
            let addReviewNavController = storyboard?.instantiateViewController(withIdentifier: "AddReviewNavController") as! UINavigationController
            let addReviewVC = addReviewNavController.viewControllers.first as! AddReviewTableViewController
            addReviewVC.toUserID = toUserID
            present(addReviewNavController, animated: true, completion: nil)
        }
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewTableViewCell
        
        return cell
    }
}
