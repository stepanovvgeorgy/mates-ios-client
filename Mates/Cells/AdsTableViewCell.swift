//
//  AdsTableViewCell.swift
//  Mates
//
//  Created by Georgy Stepanov on 01.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class AdsTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        photoImageView.layer.cornerRadius = 12
        photoImageView.clipsToBounds = true
        blurVisualEffectView.layer.cornerRadius = 12
        blurVisualEffectView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        blurVisualEffectView.clipsToBounds = true
    }
}
