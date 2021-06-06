import UIKit
import RealmSwift
class AlbumRequest:RequestManager {
    func getAlbums (owner_id:Int) {
        let url = vkRequestUrl(path: .albumsGet, queryItems: [
            URLQueryItem.init(name: "owner_id", value: "\(owner_id)"),
            URLQueryItem.init(name: "need_covers", value: "1")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            let albums = try? JSONDecoder().decode(UserAlbums.self, from: data)
            if let items = albums?.response.items {
                items.forEach() { item in
                    let album = AlbumsRealmEntity ()
                    album.id = item.id
                    album.name = item.title
                    album.photo = item.thumb_src
                    album.owner_id = owner_id
                    self.saveAlbumData(album: album)
                }
            } else {
                print ("Wrong JSON")
            }
        }
        task.resume()
    }
    
    func getPhotos (owner_id:Int, album_id:Int) {
        let url = vkRequestUrl(path: .photosGet, queryItems: [
            URLQueryItem.init(name: "owner_id", value: "\(owner_id)"),
            URLQueryItem.init(name: "album_id", value: "\(album_id)")
        ])
        
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            
            let photos = try? JSONDecoder().decode(UserPhotos.self, from: data)
            if let items = photos?.response.items {
                items.forEach {item in
                    for i in 0 ..< item.sizes.count {
                        guard item.sizes[i].type == "y" else {continue}
                        let photo = PhotoRealmEntity ()
                        photo.album_id = item.album_id
                        photo.owner_id = item.owner_id
                        photo.photo = item.sizes[i].url
                        self.savePhotoData(photo: photo)
                        //                    for i in 0 ..< item.sizes.count {
                        //                        guard item.sizes[i].type == "y" else {continue}
                        //                        let url = item.sizes[i].url
                        //                        photo.photo.append(<#T##other: String##String#>)
                    }
                    
                    //                    item.sizes.forEach () -> String {size in
                    //                        guard size.type == "y" else {return}
                    //                        let photo = size.url
                    //                        return photo
                    //                    }
                    
                    //                        let imageTask = Session.session.urlSession.dataTask(with: URL(string: item.sizes[i].url)!) { (imageData, _, _) in
                    //                            if let imageData = imageData
                    //                               ,let image = UIImage(data: imageData) {
                    //                                self.photosList.append(.init(album_id: items[0].album_id, photo:image))
                }
                //                        imageTask.resume()
            } else {
                print ("Wrong JSON")
            }
        }
        task.resume()
    }
}

extension AlbumRequest {
    struct Albums {
        let name:String
        let id:Int
        let photo:UIImage
    }
    struct UserAlbums:Decodable {
        let response: AlbumResponse
    }
    struct AlbumResponse:Decodable {
        let count:Int
        let items:[AlbumItems]
    }
    struct AlbumItems:Decodable {
        let title:String
        let id:Int
        let thumb_src:String
        let size:Int
    }
}

extension AlbumRequest {
    
    struct UserPhotos:Decodable {
        let response: PhotoResponse
    }
    struct PhotoResponse:Decodable {
        let count:Int
        let items:[PhotoItems]
    }
    struct PhotoItems:Decodable {
        let album_id:Int
        let owner_id:Int
        let sizes:[PhotoSizes]
    }
    struct PhotoSizes:Decodable {
        let url:String
        let type:String
    }
    
    struct Photos {
        let album_id:Int?
        let photo:UIImage
    }
}

extension AlbumRequest {
    func saveAlbumData (album:AlbumsRealmEntity) {
        do {
            let realm = try Realm ()
            try realm.write() {
                realm.add(album , update: .modified)
            }
        } catch {
            print (error.localizedDescription)
        }
    }
}

extension AlbumRequest {
    func savePhotoData (photo: PhotoRealmEntity) {
        do {
            let realm = try Realm()
            try realm.write() {
                realm.add(photo, update: .modified)
            }
        }catch {
            print (error.localizedDescription)
        }
    }
    
//    func loadPhoto (owner_id:Int, album_id:Int) {
//        
//        let realm = try! Realm ()
//        let photos = realm.objects(PhotoRealmEntity.self).filter("owner_id == \(owner_id) AND album_id == \(album_id)")
//        var photosList = [UIImage()]
//            for i in 0 ..< photos.count {
//            let url = URL(string: photos[i].photo)
//            let imageTask = Session.session.urlSession.dataTask(with: url!) { (imageData, _, _) in
//                if let imageData = imageData ,let image = UIImage(data: imageData) {
//                    print (photosList.count)
//                    photosList.append(image)
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    return print (photosList)
//                    }
//                }
//            }
//            imageTask.resume()
//        }
//    }
}
