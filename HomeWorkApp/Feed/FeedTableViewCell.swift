//
//  FeedTableViewCell.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 26.03.2021.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var feedLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.image = #imageLiteral(resourceName: "unnamed")
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = 20
        feedLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        feedImage.image = #imageLiteral(resourceName: "d0311cd8-0115-11e7-a59f-6e714efd800d.800x600")
        feedImage.contentMode = .scaleAspectFill
        let onImageTap = UITapGestureRecognizer (target: self, action: #selector(onTap))
        userImage.addGestureRecognizer(onImageTap)
    }
    
    @objc private func onTap () {
        let spring = CASpringAnimation (keyPath: "transform.scale")
        spring.fromValue = 1
        spring.toValue = 0.95
        spring.stiffness = 200
        spring.initialVelocity = 1
        spring.damping = 0.5
        spring.duration = 0.4
        userImage.layer.add(spring, forKey: nil)
//        UIView.transition(with: userImage, duration: 0.5, options: .transitionFlipFromBottom, animations: {
//            self.userImage.image = #imageLiteral(resourceName: "unnamed")
//        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    
}
