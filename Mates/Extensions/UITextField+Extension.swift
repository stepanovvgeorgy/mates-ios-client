//
//  UITextField+Extension.swift
//  Mates
//
//  Created by Georgy Stepanov on 30.03.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setIcon(_ image: UIImage) {
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 6, width: 17, height: 17))
        
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        
        iconContainerView.addSubview(iconView)
        
        self.leftView = iconContainerView
        self.leftView?.alpha = 0.5
        self.leftViewMode = .always
    }
    
}
