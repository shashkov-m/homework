import UIKit

class NewsfeedUITableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {    
    @IBOutlet weak var collectionView: UICollectionView!
    var currentIndex:Int = 0
    var url:URL?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension NewsfeedUITableViewCell: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib (nibName: "NewsfeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsfeedCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsfeedCollectionViewCell", for: indexPath) as! NewsfeedCollectionViewCell
        cell.backgroundColor = .blue
        cell.image.sd_setImage(with: url)
        cell.image.contentMode = .scaleAspectFill
        cell.label.text = "\(currentIndex)"
        return cell
    }
}



