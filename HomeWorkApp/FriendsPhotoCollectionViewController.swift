//
//  FriendsPhotoCollectionViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 07.03.2021.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "FriendPhotoItem"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return userPhotos.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendsPhotoCollectionViewCell
        
        cell.imageView.image = userPhotos [indexPath.item]
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
    
}

