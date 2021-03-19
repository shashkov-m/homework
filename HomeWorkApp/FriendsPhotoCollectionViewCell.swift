//
//  FriendsPhotoCollectionViewCell.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 14.03.2021.
//

import UIKit

class FriendsPhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func like(_ sender: Any) {
        likeButton.isSelected.toggle()
        likeButton.tintColor = likeButton.isSelected ? .red : .white
        likeButton.setImage(UIImage (systemName: "heart.fill"), for: .selected)
        likeButton.setImage(UIImage (systemName: "heart"), for: .normal)
    }
}
