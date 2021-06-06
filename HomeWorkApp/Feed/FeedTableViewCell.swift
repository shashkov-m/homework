//
//  FeedTableViewCell.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 26.03.2021.
//

import UIKit
import Kingfisher
import SDWebImage
class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsContentView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCount:UILabel!
    @IBOutlet weak var commentImage:UIImageView!
    @IBOutlet weak var commentCount:UILabel!
    @IBOutlet weak var repostImage:UIImageView!
    @IBOutlet weak var repostCount:UILabel!
    @IBOutlet weak var viewsImage:UIImageView!
    @IBOutlet weak var viewsCount:UILabel!
    
    //MARK: - Images
    let firstImg = UIImageView ()
    let gifImg = SDAnimatedImageView ()
    let secondImg = UIImageView ()
    let thirdImg = UIImageView ()
    let fourthImg = UIImageView ()
    let countLabel = UILabel ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repostImage.tintColor = .gray
        viewsImage.tintColor = .gray
        commentImage.tintColor = .gray
        likeImage.tintColor = .gray
        commentImage.image = UIImage (systemName: "bubble.left")
        repostImage.image = UIImage (systemName: "arrowshape.turn.up.right")
        viewsImage.image = UIImage (systemName: "eye")
        
        firstImg.contentMode = .scaleToFill
        secondImg.contentMode = .scaleToFill
        thirdImg.contentMode = .scaleToFill
        fourthImg.contentMode = .scaleToFill
        gifImg.contentMode = .scaleToFill
        
        gifImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        firstImg.kf.indicatorType = .activity
        countLabel.font = UIFont.boldSystemFont(ofSize: 40)
        countLabel.textAlignment = .center
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsContentView.subviews.forEach {subview in
            subview.removeFromSuperview()
        }
        
        firstImg.kf.cancelDownloadTask()
        secondImg.kf.cancelDownloadTask()
        thirdImg.kf.cancelDownloadTask()
        fourthImg.kf.cancelDownloadTask()
        gifImg.sd_cancelCurrentImageLoad()
        
        firstImg.image = nil
        secondImg.image = nil
        thirdImg.image = nil
        fourthImg.image = nil
        gifImg.image = nil
        
    }
    
    //    @objc private func onTap () {
    //        let spring = CASpringAnimation (keyPath: "transform.scale")
    //        spring.fromValue = 1
    //        spring.toValue = 0.95
    //        spring.stiffness = 200
    //        spring.initialVelocity = 1
    //        spring.damping = 0.5
    //        spring.duration = 0.4
    //        userImage.layer.add(spring, forKey: nil)
    ////        UIView.transition(with: userImage, duration: 0.5, options: .transitionFlipFromBottom, animations: {
    ////            self.userImage.image = #imageLiteral(resourceName: "unnamed")
    ////        })
    //    }
    //
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(false, animated: false)
    //        selectionStyle = .none
    //
    //        // Configure the view for the selected state
    //    }
    
}
