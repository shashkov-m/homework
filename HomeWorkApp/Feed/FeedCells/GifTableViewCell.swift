import UIKit
import SDWebImage
import RealmSwift
class GifTableViewCell: UITableViewCell, NewsfeedCell {
    let queue = DispatchQueue (label: "gifCellQueue")
    var newsList:Results <NewsfeedRealmEntuty>?
    let gifView = SDAnimatedImageView ()
    

    @IBOutlet weak var view: UIView!
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gifView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifView.image = nil
    }
}
