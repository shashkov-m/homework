//
//  NewsfeedCollectionViewCell.swift
//  HomeWorkApp
//
//  Created by Max on 23.06.2021.
//

import UIKit

class NewsfeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        image.image = nil
    }
}
