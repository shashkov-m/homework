import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "FriendPhotoItem"
    var album_id:Int = 0
    var photosList:[AlbumRequest.Photos] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var indexPath:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let photo = photosList.filter {$0.album_id == album_id}
        return photo.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendsPhotoCollectionViewCell
        let photo = photosList.filter {$0.album_id == album_id}
        cell.imageView.image = photo [indexPath.item].photo
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath.item
        performSegue(withIdentifier: "toPhoto", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto",
           let photosVC = segue.destination as? PhotoViewController {
            photosVC.photosList = self.photosList
            photosVC.selectedPhoto = self.indexPath
            photosVC.album_id = self.album_id
        }
    }

}

