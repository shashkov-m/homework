import UIKit
protocol NewsfeedCell {
    
    var avatarView: UIImageView! { get set }
    var nameLabel: UILabel! { get set }
    var dateLabel: UILabel! { get set }
    var postLabel: UILabel! { get set }
    var likeView: UIImageView! { get set }
    var likeLabel: UILabel! { get set }
    var commentView: UIImageView! { get set }
    var commentLabel: UILabel! { get set }
    var repostView: UIImageView! { get set }
    var repostLabel: UILabel! { get set }
    var viewsView: UIImageView! { get set }
    var viewsLabel: UILabel! { get set }
    
}
