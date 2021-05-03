//import UIKit
//class PhotosRequest:RequestManager {
//
//
//    func getPhotos (owner_id:Int, album_id:Int) {
//        let url = vkRequestUrl(path: .photosGet, queryItems: [
//            URLQueryItem.init(name: "owner_id", value: "\(owner_id)"),
//            URLQueryItem.init(name: "album_id", value: "\(album_id)")
//        ])
//
//        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
//            guard let data = data else {return}
//
//            let photos = try? JSONDecoder().decode(UserPhotos.self, from: data)
//            if let items = albums?.response.items {
//
//                for i in 0 ..< items.count {
//                    let imageTask = Session.session.urlSession.dataTask(with: URL(string: items[i].thumb_src)!) { (imageData, _, _) in
//                        if let imageData = imageData {
//                            let image = UIImage(data: imageData)!
//                            self.albumsList.append(Albums(name: items[i].title, id: items[i].id, photo: image))
//                        }
//                    }
//                    imageTask.resume()
//                }
//            } else {
//                print ("Wrong JSON")
//            }
//        }
//        task.resume()
//    }
//}
//
//extension PhotosRequest {
//    struct Albums {
//        let name:String
//        let id:Int
//        let photo:UIImage
//    }
//}
//
//extension PhotosRequest {
//    struct UserAlbums:Decodable {
//        let response: AlbumResponse
//    }
//    struct AlbumResponse:Decodable {
//        let count:Int
//        let items:[AlbumItems]
//    }
//    struct AlbumItems:Decodable {
//        let title:String
//        let id:Int
//        let thumb_src:String
//        let size:Int
//    }
//}
//
//extension PhotosRequest {
//
//    struct UserPhotos:Decodable {
//        let response: AlbumResponse
//    }
//    struct PhotoResponse:Decodable {
//        let count:Int
//        let items:[PhotoItems]
//    }
//    struct PhotoItems:Decodable {
//        let sizes:[PhotoSizes]
//    }
//    struct PhotoSizes:Decodable {
//        let url:String
//        let type:String
//    }
//}
