//
//  ButtonsTableViewCell.swift
//  Mates
//
//  Created by Georgy Stepanov on 01.05.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
