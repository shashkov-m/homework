import UIKit
import RealmSwift
import Kingfisher
class AlbumsCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    let albumsRequest = AlbumRequest()
    var user_id:Int = 0
    var album_id:Int = 0
    var albumName:String = ""
    let realm = try! Realm ()
    var albums:Results<AlbumsRealmEntity>?
    var token:NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsRequest.getAlbums(owner_id: user_id)
        self.collectionView!.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        albums = realm.objects(AlbumsRealmEntity.self).filter("owner_id == \(user_id)")
        token = albums?.observe{[weak self] changes in
            switch changes {
            
            case .initial(_):
                self?.collectionView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.collectionView.reloadData()
            case .error(let error):
                print (error.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumsCollectionViewCell
        guard let albums = albums else { return cell }
        let album = albums [indexPath.item]
        cell.label.text = album.name
        let url = URL (string: album.photo)
        cell.imageView.kf.setImage(with: url)
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albums = albums else { return }
        let album = albums [indexPath.item]
        self.album_id = album.id
        self.albumName = album.name
        self.performSegue(withIdentifier: "toPhotos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotos",
           let photosVC = segue.destination as? FriendsPhotoCollectionViewController {
            photosVC.album_id = album_id
            photosVC.user_id = user_id
            photosVC.albumName = albumName
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    deinit {
        token?.invalidate()
    }
}
