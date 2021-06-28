import UIKit
import SDWebImage
import RealmSwift
class GifTableViewCell: UITableViewCell {
    let gifView = SDAnimatedImageView ()
    
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gifView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        gifView.autoPlayAnimatedImage = false
        
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
