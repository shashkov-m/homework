import UIKit

class NewsfeedUITableViewCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        collectionView.delegate = self
        //        collectionView.dataSource = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}
//extension NewsfeedUITableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        collectionView.register(UINib (nibName: "NewsfeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsfeedCollectionViewCell")
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsfeedCollectionViewCell", for: indexPath) as! NewsfeedCollectionViewCell
//        cell.backgroundColor = .blue
//        cell.image.contentMode = .scaleAspectFill
//
//        return cell
//    }
//

//}

extension NewsfeedUITableViewCell: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
