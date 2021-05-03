import UIKit

class AlbumsCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    let albumsRequest = AlbumRequest()
    var user_id:Int = 0
    var album_id:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        albumsRequest.getAlbums(owner_id: user_id)
        self.collectionView!.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsRequest.albumsList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumsCollectionViewCell
        let album = albumsRequest.albumsList [indexPath.item]
        cell.label.text = album.name
        cell.imageView.image = album.photo
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albumsRequest.albumsList [indexPath.item]
        album_id = album.id
        albumsRequest.getPhotos(owner_id: user_id, album_id: album_id)
        DispatchQueue.main.asyncAfter (deadline: .now() + 1) {
            self.performSegue(withIdentifier: "toPhotos", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotos",
           let photosVC = segue.destination as? FriendsPhotoCollectionViewController {
            photosVC.album_id = album_id
            photosVC.photosList = albumsRequest.photosList
            photosVC.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        print (user_id)
    }
}
