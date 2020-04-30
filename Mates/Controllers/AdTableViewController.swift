//
//  AdTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 05.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit
import SDWebImage

class AdTableViewController: UITableViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var subwayLabel: UILabel!
    @IBOutlet weak var timeToSubwayLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var oneRoomImageView: UIImageView!
    @IBOutlet weak var twoRoomsImageView: UIImageView!
    @IBOutlet weak var threeRoomsImageView: UIImageView!
    @IBOutlet weak var fourRoomsImageView: UIImageView!
    @IBOutlet weak var fiveRoomsImageView: UIImageView!
    @IBOutlet weak var oneRoomSaleImageView: UIImageView!
    @IBOutlet weak var twoRoomsSaleImageView: UIImageView!
    @IBOutlet weak var threeRoomsSaleImageView: UIImageView!
    @IBOutlet weak var fourRoomsSaleImageView: UIImageView!
    @IBOutlet weak var fiveRoomsSaleImageView: UIImageView!
    @IBOutlet weak var mateGenderImageView: UIImageView!
    @IBOutlet weak var animalsImageView: UIImageView!
    @IBOutlet weak var timeToSaleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceToSaleLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var walkImageView: UIImageView!
    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var cSaleImageView: UIImageView!
    @IBOutlet weak var animalsLabel: UILabel!
    @IBOutlet weak var currentImageNumberLabel: UILabel!
    @IBOutlet weak var countImagesLabel: UILabel!
    
    var ad: Ad?
    
    var adImages: [String] = Array()
    let imageCellID = "ImageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "BigImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: imageCellID)
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
    }
    
    func getAdByID(_ id: Int?) {
        if let id = id {
            NetworkManager.shared.getAdByID(id) { (ad) in
                self.ad = ad
                self.setDataFromAd(ad: ad)
                self.imagesCollectionView.reloadData()
                
                let currentUserID = UserDefaults.standard.value(forKey: "user_id") as! Int

                if ad.userID == currentUserID {
                    self.setEditBarButton()
                }
            }
            NetworkManager.shared.sendViewed(adID: id) {
                NetworkManager.shared.getViewed(adID: id) { (viewed) in
                    self.viewsCountLabel.text = String(viewed)
                }
            }
        }
    }
    
    func setEditBarButton() {
        let editBarButtonItem = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editAd(_:)))
        navigationItem.setRightBarButton(editBarButtonItem, animated: true)
    }
    
    @objc func editAd(_ sender: UIBarButtonItem) {
        print("editAd")
    }
    
    func setDataFromAd(ad: Ad?) {
                
        guard let adObj = ad else {return}
        
        dateLabel.text = Helper.shared.convertTimestamp(dateString: adObj.createdDate!)
        
        nameLabel.text = "\(adObj.userFirstName ?? "") \(adObj.userLastName ?? "")"
        
        adImages = adObj.images!
        
        countImagesLabel.text = "\(adObj.images?.count ?? 0)"
        
        guard let avatarUrl = URL(string: adObj.userAvatarString ?? "") else {return}

        avatarImageView.sd_setImage(with: avatarUrl) { (image, error, cache, url) in
            if error != nil {
                self.avatarImageView.image = image
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        subwayLabel.text = adObj.subway
        
        if adObj.timeToSubway == "" {
            walkImageView.isHidden = true
        }
        
        timeToSubwayLabel.text = adObj.timeToSubway
        addressLabel.text = "\(adObj.street ?? "") \(adObj.numberOfHouse ?? "") \(adObj.housing ?? "")"

        switch adObj.genderMate {
        case 0:
            mateGenderImageView.image = #imageLiteral(resourceName: "woman")
        case 1:
            mateGenderImageView.image = #imageLiteral(resourceName: "man")
        case 2:
            mateGenderImageView.image = #imageLiteral(resourceName: "man_woman")
        default:
            break
        }
        
        if adObj.animals == true {
            animalsImageView.image = #imageLiteral(resourceName: "dog")
        } else {
            animalsImageView.image = #imageLiteral(resourceName: "no_animals")
            animalsLabel.text = "Без животных"
        }
        
        switch adObj.numberOfRooms {
        case 0:
            cImageView.image = #imageLiteral(resourceName: "c-green")
        case 1:
            oneRoomImageView.image = #imageLiteral(resourceName: "one-green")
        case 2:
            twoRoomsImageView.image = #imageLiteral(resourceName: "two-green")
        case 3:
            threeRoomsImageView.image = #imageLiteral(resourceName: "three-green")
        case 4:
            fourRoomsImageView.image = #imageLiteral(resourceName: "four-green")
        case 5:
            fiveRoomsImageView.image = #imageLiteral(resourceName: "five-green")
        default:
            break
        }
        
        switch adObj.numberOfSalesRooms {
        case 0:
            cSaleImageView.image = #imageLiteral(resourceName: "c-green")
        case 1:
            oneRoomSaleImageView.image = #imageLiteral(resourceName: "one-green")
        case 2:
            twoRoomsSaleImageView.image = #imageLiteral(resourceName: "two-green")
        case 3:
            threeRoomsSaleImageView.image = #imageLiteral(resourceName: "three-green")
        case 4:
            fourRoomsSaleImageView.image = #imageLiteral(resourceName: "four-green")
        case 5:
            fiveRoomsSaleImageView.image = #imageLiteral(resourceName: "five-green")
        default:
            break
        }
        
        priceLabel.text = String(adObj.price!)
        
        infoTextLabel.text = adObj.infoText
    
    }

    @IBAction func connectAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "Позвонить", style: .default) { (action) in
            print("call")
        }
        let msgAction = UIAlertAction(title: "Написать личное сообщение", style: .default) { (action) in
            print("msg")
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (action) in
            print("cancel")
        }
        actionSheet.addAction(callAction)
        actionSheet.addAction(msgAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true) {
            
        }
    }
    
    @IBAction func actionShowReviews(_ sender: UIButton) {
        
        let reviewsVC = storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsViewController
        
        reviewsVC.toUserID = ad?.userID
        
        navigationController?.pushViewController(reviewsVC, animated: true)
        
    }
    
}

extension AdTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellID, for: indexPath) as! BigImageCollectionViewCell
        
        let imageURLString = adImages[indexPath.row]
        
        guard let imageUrl = URL(string: imageURLString) else {return cell}

        cell.photoImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .scaleDownLargeImages)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentImageNumberLabel.text = "\(indexPath.row + 1)"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = collectionView.frame
        
        let size = CGSize(width: frame.width, height: frame.height)
        
        return size
    }
}
