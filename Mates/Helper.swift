//
//  Helper.swift
//  Mates
//
//  Created by Georgy Stepanov on 31.03.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class Helper {
    
    class func startApp(window: UIWindow?) {
        
        let token = UserDefaults.standard.value(forKey: "token")
        let user_id = UserDefaults.standard.value(forKey: "user_id")

        let isAuth = token != nil && user_id != nil
        
        if isAuth {
            let innerTabBarController = AppDelegate.storyboard.instantiateViewController(withIdentifier: "InnerTabBarController")
            window?.rootViewController = innerTabBarController
        }
    }
    
    class func styledNavigationBar(navigationController: UINavigationController?, backgroundColor: UIColor?, textColor: UIColor?, isTranslucent: Bool?) {
        navigationController?.navigationBar.barTintColor = backgroundColor ?? UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: textColor ?? UIColor.white]
        navigationController?.navigationBar.isTranslucent = isTranslucent ?? true
    }
    
    class func showInfoAlert(title: String?, message: String?) -> UIAlertController? {
        guard let title = title else {return nil}
        guard let message = message else {return nil}
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(closeButton)
        return alert
    }
    
    class func navigationBarWithImage(vc: UIViewController?, imageNamed: String, width: Double, height: Double) {
        let image = UIImage(named: imageNamed)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        vc?.navigationItem.titleView = imageView
    }
    
    class func customBarButtonWithImage(vc: UIViewController?, selector: Selector, image: UIImage) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        button.setImage(image, for: .normal)
        button.addTarget(vc, action: selector, for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 24)
        width?.isActive = true
        
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 24)
        height?.isActive = true
        
        return barButton
    }
}
