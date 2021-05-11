import UIKit
import RealmSwift
import Kingfisher
class FriendsPhotoCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "FriendPhotoItem"
    let albumRequest = AlbumRequest ()
    let realm = try! Realm ()
    var user_id:Int = 0
    var album_id:Int = 0
    var indexPath:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        albumRequest.getPhotos(owner_id: user_id, album_id: album_id)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photos = realm.objects(PhotoRealmEntity.self).filter("album_id == \(album_id) AND owner_id == \(user_id)")
        return photos.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendsPhotoCollectionViewCell
        let photos = realm.objects(PhotoRealmEntity.self).filter("album_id == \(album_id) AND owner_id == \(user_id)") [indexPath.row]
        let url = URL(string: photos.photo)
        cell.imageView.kf.setImage(with: url)
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
            photosVC.selectedPhoto = self.indexPath
            photosVC.album_id = self.album_id
            photosVC.user_id = self.user_id
        }
    }

}

