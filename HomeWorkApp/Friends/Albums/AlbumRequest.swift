import UIKit

class AlbumRequest:RequestManager {
    
    var albumsList:[Albums] = []
    var photosList:[Photos] = []
    
    func getAlbums (owner_id:Int) {
        let url = vkRequestUrl(path: .albumsGet, queryItems: [
            URLQueryItem.init(name: "owner_id", value: "\(owner_id)"),
            URLQueryItem.init(name: "need_covers", value: "1")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            let albums = try? JSONDecoder().decode(UserAlbums.self, from: data)
            if let items = albums?.response.items {
                for i in 0 ..< items.count {
                    let imageTask = Session.session.urlSession.dataTask(with: URL(string: items[i].thumb_src)!) { (imageData, _, _) in
                        if let imageData = imageData {
                            let image = UIImage(data: imageData)!
                            self.albumsList.append(Albums(name: items[i].title, id: items[i].id, photo: image))
                        }
                    }
                    imageTask.resume()
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
                        let imageTask = Session.session.urlSession.dataTask(with: URL(string: item.sizes[i].url)!) { (imageData, _, _) in
                            if let imageData = imageData
                               ,let image = UIImage(data: imageData) {
                                    self.photosList.append(.init(album_id: items[0].album_id, photo:image))
                            }
                        }
                        
                        imageTask.resume()
                    }
                }
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
        let id:Int
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
