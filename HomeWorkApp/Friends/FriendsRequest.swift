//
//  FriendsRequest.swift
//  HomeWorkApp
//
//  Created by Max on 28.04.2021.
//

import UIKit
import RealmSwift
class FriendsRequest {
    let requestManager = RequestManager ()
    
    var friendsList:[Friends] = []
    
    func getFriendsList () {
        let url = requestManager.vkRequestUrl(path: .friendsGet,queryItems: [
            URLQueryItem.init(name: "fields", value: "city,photo_100"),
            URLQueryItem.init(name: "order", value: "hints")
        ])
        print (url)
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            
            let friends = try? JSONDecoder().decode(UserFriends.self, from: data)
            if let items = friends?.response.items {
                
                for i in 0 ..< items.count {
                    let imageTask = Session.session.urlSession.dataTask(with: URL(string: items[i].photo_100)!) { (imageData, _, _) in
                        if let imageData = imageData {
                            let image = UIImage(data: imageData)!
                            self.friendsList.append(Friends(name: "\(items[i].first_name) \(items[i].last_name)", city: "\(items [i].city?.title ?? "")", id: items[i].id, photo: image))
                            
                            //MARK: - Realm
                            let friend = FriendsRealmEntity ()
                            friend.name = "\(items[i].first_name) \(items[i].last_name)"
                            friend.city = "\(items [i].city?.title ?? "")"
                            friend.id = items[i].id
                            friend.photo = items[i].photo_100
                            self.saveFriendsData(friend: friend)
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
}

extension FriendsRequest {
    
    struct UserFriends:Decodable {
        let response: Response
    }
    struct Response:Decodable {
        let count:Int
        let items:[Items]
    }
    struct Items:Decodable {
        let first_name:String
        let id:Int
        let last_name:String
        let city:City?
        let photo_100:String
    }
    struct City:Decodable {
        let title:String
    }
    
    struct Friends {
        let name:String
        let city:String
        let id:Int
        let photo:UIImage
    }
}

extension FriendsRequest {
    
    func saveFriendsData (friend: FriendsRealmEntity) {
        do {
            let realm = try Realm ()
            try realm.write () {
                realm.add(friend)
            }
            print ("Writing in realm - \(friend)")
            print("Realm path = \(realm.configuration.fileURL)")
        } catch {
            print (error.localizedDescription)
        }
    }
}

