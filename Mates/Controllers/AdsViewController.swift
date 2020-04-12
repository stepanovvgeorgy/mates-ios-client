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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.320400238, blue: 0.3293212056, alpha: 1)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
                
        getAds()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        getAds()
    }
    
    func getAds() {
        NetworkManager.shared.getAds(url: "/ad/min?page=\(pageNumber)&limit=\(adsLimit)") { (ads) in
            self.adsArray.append(contentsOf: ads)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let addAdsVC = storyboard?.instantiateViewController(withIdentifier: "AddAdsNavController")
        present(addAdsVC!, animated: true, completion: nil)
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
    
        cell.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.sd_imageIndicator?.startAnimatingIndicator()
        cell.photoImageView.sd_setImage(with: imageUrl) { (image, error, cache, url) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                cell.photoImageView.image = image
                cell.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let adVC = storyboard?.instantiateViewController(withIdentifier: "AdTableViewController")
        
        navigationController?.pushViewController(adVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == adsArray.count - 1 {
            pageNumber = pageNumber + 1
            getAds()
        }
    }
}
