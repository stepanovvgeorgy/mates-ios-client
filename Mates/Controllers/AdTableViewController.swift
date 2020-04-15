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
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var subwayLabel: UILabel!
    @IBOutlet weak var timeToSubwayLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var oneRoomImageView: UIImageView!
    @IBOutlet weak var twoRoomsImageView: UIImageView!
    @IBOutlet weak var threeRoomsImageView: UIImageView!
    @IBOutlet weak var fourRoomsImageView: UIImageView!
    @IBOutlet weak var fiveRoomsImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var oneRoomSaleImageView: UIImageView!
    @IBOutlet weak var twoRoomsSaleImageView: UIImageView!
    @IBOutlet weak var threeRoomsSaleImageView: UIImageView!
    @IBOutlet weak var fourRoomsSaleImageView: UIImageView!
    @IBOutlet weak var fiveRoomsSaleImageView: UIImageView!
    @IBOutlet weak var plusSaleImageView: UIImageView!
    @IBOutlet weak var mateGenderImageView: UIImageView!
    @IBOutlet weak var animalsImageView: UIImageView!
    @IBOutlet weak var timeToSaleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceToSaleLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var walkImageView: UIImageView!
    
    var ad: Ad?
    
    var adImages: [UIImage] = Array()
    let imageCellID = "ImageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "BigImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: imageCellID)
        
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        setDataFromAd(ad: ad)
    }
    
    func setDataFromAd(ad: Ad?) {
        guard let adObj = ad else {return}
        
        dateLabel.text = adObj.createdDate
        nameLabel.text = "\(adObj.userFirstName ?? "") \(adObj.userLastName ?? "")"
        
        guard let avatarUrl = URL(string: adObj.userAvatarString ?? "") else {return}

        avatarImageView.sd_setImage(with: avatarUrl) { (image, error, cache, url) in
            if error != nil {
                self.avatarImageView.image = image
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        ageLabel.text = adObj.userBDate
        subwayLabel.text = adObj.subway
        
        if adObj.timeToSubway == "" {
            walkImageView.isHidden = true
        }
        
        timeToSubwayLabel.text = adObj.timeToSubway
        addressLabel.text = "\(adObj.street ?? ""), \(adObj.numberOfHouse ?? ""), \(adObj.housing ?? "")"

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
        }
        
        priceLabel.text = String(adObj.price!)
        
        infoTextLabel.text = adObj.infoText
    
    }

    @IBAction func connectAction(_ sender: UIButton) {
        
    }
}

extension AdTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellID, for: indexPath) as! BigImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = collectionView.frame
        
        let size = CGSize(width: frame.width, height: frame.height)
        
        return size
    }
}
