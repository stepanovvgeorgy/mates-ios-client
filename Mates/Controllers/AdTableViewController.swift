//
//  AdTableViewController.swift
//  Mates
//
//  Created by Georgy Stepanov on 05.04.2020.
//  Copyright © 2020 Georgy Stepanov. All rights reserved.
//

import UIKit

class AdTableViewController: UITableViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var adImages: [UIImage] = Array()
    let imageCellID = "ImaageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "BigImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: imageCellID)
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
