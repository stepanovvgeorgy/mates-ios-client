//
//  PeopleTableViewCell.swift
//  Mates
//
//  Created by Georgy Stepanov on 20.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class MateTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var infoTextLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        avatarImageView.layer.cornerRadius = 23
        avatarImageView.clipsToBounds = true
    }
}
