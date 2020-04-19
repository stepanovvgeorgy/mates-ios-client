//
//  AdsViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 01.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit
import SDWebImage

class AdsViewController: UIViewController {

    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    
    var adsArray = Array<Ad>()
    
    var pageNumber = 1
    let adsLimit = 5
    var totalCount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVC(_:)), name: NSNotification.Name(rawValue: "adsReloadVC"), object: nil)
        
        getAds()
    }
    
    @objc func reloadVC(_ notification: Notification) {
        activityIndicator.startAnimating()
        pageNumber = 1
        adsArray = Array<Ad>()
        totalCount = ""
        getAds()
    }
        
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
    }
    
    func getAds() {
        print("adsVC getAds pageNumber=\(pageNumber); limit=\(adsLimit)")
        NetworkManager.shared.getAds(url: "/ad/min?page=\(pageNumber)&limit=\(adsLimit)") { (ads, total) in
            self.adsArray.append(contentsOf: ads)
            self.totalCount = total
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            print("adsArray.count = \(self.adsArray.count)")
            print("!!!adsVC getAds clouser pageNumber=\(self.pageNumber); limit=\(self.adsLimit)")
            
        }
    }
    
    
    @IBAction func actionAdd(_ sender: Any) {
        let navigationControllerAddAds = storyboard?.instantiateViewController(withIdentifier: "AddAdsNavController") as! UINavigationController
        present(navigationControllerAddAds, animated: true, completion: nil)
    }
}


extension AdsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! AdsTableViewCell
        
        let ad = adsArray[indexPath.row]
                        
        cell.locationLabel.text = ad.subway

        var time = ""
        
        if ad.priceToTime! == 0 {
            time = "в месяц"
        } else {
            time = "за сутки"
        }
        
        cell.priceLabel.text = "\(ad.price!) \(time)"
        
        guard let imageUrl = URL(string: ad.previewImage!) else {return cell}
        
        cell.photoImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, completed: nil)
        
        guard let avatarUrl = URL(string: ad.userAvatarString!) else {return cell}
        
        cell.avatarImageView.sd_setImage(with: avatarUrl, placeholderImage: #imageLiteral(resourceName: "user-circle"), options: .scaleDownLargeImages)
        
        cell.firstNameLabel.text = ad.userFirstName
                
        if ad.type == 0 {
            cell.typeViewLabel.text = "Ищу соседа"
            cell.typeView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else if ad.type == 1 {
            cell.typeView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.typeViewLabel.text = "Сдам квартиру"
        }
        
        cell.favoriteButton.setImage(#imageLiteral(resourceName: "passion"), for: .normal)
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(actionAddFavorite(_:)), for: .touchUpInside)
                
        return cell
    }
    
    @objc func actionAddFavorite(_ sender: UIButton) {
        
        if sender.image(for: .normal) == UIImage(named: "passion") {
            sender.setImage(#imageLiteral(resourceName: "passion-fill"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "passion"), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAd = adsArray[indexPath.row]
        
        let adVC = self.storyboard?.instantiateViewController(withIdentifier: "AdTableViewController") as! AdTableViewController
        
        adVC.getAdByID(selectedAd.id)
        
        self.navigationController?.pushViewController(adVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == adsArray.count - 1 {
            if adsArray.count < Int(totalCount!)! {
                pageNumber = pageNumber + 1
                getAds()
            } else {
                print("All ads loaded")
            }
        }
    }
}
