import UIKit
import RealmSwift
import Kingfisher
class AlbumsCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    let albumsRequest = AlbumRequest()
    var user_id:Int = 0
    var album_id:Int = 0
    let realm = try! Realm ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsRequest.getAlbums(owner_id: user_id)
        self.collectionView!.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let album = realm.objects(AlbumsRealmEntity.self).filter("owner_id == \(user_id)")
        return album.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumsCollectionViewCell
        let album = realm.objects(AlbumsRealmEntity.self).filter("owner_id == \(user_id)") [indexPath.item]
        cell.label.text = album.name
        let url = URL (string: album.photo)
        cell.imageView.kf.setImage(with: url)
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = realm.objects(AlbumsRealmEntity.self).filter("owner_id == \(user_id)") [indexPath.item]
        self.album_id = album.id
        //        DispatchQueue.main.asyncAfter (deadline: .now() + 1) {
        self.performSegue(withIdentifier: "toPhotos", sender: self)
        //  }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotos",
           let photosVC = segue.destination as? FriendsPhotoCollectionViewController {
            photosVC.album_id = album_id
            photosVC.user_id = user_id
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
}
