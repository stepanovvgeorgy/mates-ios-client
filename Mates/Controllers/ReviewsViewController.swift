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
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var toUserID: Int?
    
    var reviewsArray = Array<Review>()
    
    var pageNumber: Int = 1
    let limit: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                
        var tableViewBottomInset: CGFloat = 50
        
        let currentUserID = UserDefaults.standard.value(forKey: "user_id") as! Int
        
        if toUserID == currentUserID {
            addReviewButton.isHidden = true
            tableViewBottomInset = 0
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableViewBottomInset, right: 0)
        
        addReviewButton.layer.cornerRadius = 22
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshVC(_:)),
                                               name: Notification.Name("reviewDidSend"),
                                               object: nil)
        
        getReviews()
    }
    
    func getReviews() {
        if let toUserID = toUserID {
            activityIndicator.startAnimating()
            NetworkManager.shared.getReviews(url: "/review/user/\(toUserID)?page=\(pageNumber)&limit=\(limit)") { (reviews) in
                self.tableView.isHidden = false
                self.emptyLabel.isHidden = true
                self.reviewsArray.append(contentsOf: reviews)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func refreshVC(_ notification: Notification) {
        activityIndicator.startAnimating()
        pageNumber = 1
        reviewsArray = Array<Review>()
        getReviews()
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
        return reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewTableViewCell
        
        let review = reviewsArray[indexPath.row]
        
        cell.resultLabel.text = review.result
        cell.reviewTextLabel.text = review.text
        cell.fullnameLabel.text = "\(review.authorFirstName!) \(review.authorLastName!)"
    
        switch review.star {
        case 1:
            cell.oneStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.twoStarImageView.image = #imageLiteral(resourceName: "star-empty")
            cell.threeStarImageView.image = #imageLiteral(resourceName: "star-empty")
            cell.fourStarImageView.image = #imageLiteral(resourceName: "star-empty")
            cell.fiveStarImageView.image = #imageLiteral(resourceName: "star-empty")
        case 2:
            cell.oneStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.twoStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.threeStarImageView.image = #imageLiteral(resourceName: "star-empty")
            cell.fourStarImageView.image = #imageLiteral(resourceName: "star-empty")
            cell.fiveStarImageView.image = #imageLiteral(resourceName: "star-empty")
        case 3:
            cell.oneStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.twoStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.threeStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.fourStarImageView.image = #imageLiteral(resourceName: "star-empty")
            cell.fiveStarImageView.image = #imageLiteral(resourceName: "star-empty")
        case 4:
            cell.oneStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.twoStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.threeStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.fourStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.fiveStarImageView.image = #imageLiteral(resourceName: "star-empty")
        case 5:
            cell.oneStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.twoStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.threeStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.fourStarImageView.image = #imageLiteral(resourceName: "star-gold")
            cell.fiveStarImageView.image = #imageLiteral(resourceName: "star-gold")
        default:
            break
        }
        
        guard let avatarURL = URL(string: review.authorAvatarUrl!) else {return cell}
        
        cell.avatarImageView.sd_setImage(with: avatarURL, placeholderImage: #imageLiteral(resourceName: "user-circle")) { (image, error, cache, url) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
        
        return cell
    }
    
}
