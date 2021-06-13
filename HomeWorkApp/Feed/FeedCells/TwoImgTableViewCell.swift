//
//  TwoImgTableViewCell.swift
//  HomeWorkApp
//
//  Created by 18261451 on 13.06.2021.
//

import UIKit

class TwoImgTableViewCell: UITableViewCell, NewsfeedCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var likeView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var commentView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var repostView: UIImageView!
    
    @IBOutlet weak var repostLabel: UILabel!
    
    @IBOutlet weak var viewsView: UIImageView!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var firstImg: UIImageView!
    
    @IBOutlet weak var secondImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstImg.contentMode = .scaleAspectFill
        secondImg.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstImg.image = nil
        secondImg.image = nil
    }
}
