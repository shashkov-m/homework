//
//  NewsfeedCollectionViewCell.swift
//
//  Created by Max on 23.06.2021.
//

import UIKit

class NewsfeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    let countLabel = UILabel ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.contentMode = .scaleAspectFill
        countLabel.font = UIFont.boldSystemFont(ofSize: 40)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .clear
    }

    override func prepareForReuse() {
        image.image = nil
        image.alpha = 1
        countLabel.text = nil
        guard self.subviews.count > 1 else { return }
        countLabel.removeFromSuperview()
    }
}
