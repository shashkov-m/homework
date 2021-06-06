import UIKit
import RealmSwift
class FriendsRequest {
    let requestManager = RequestManager ()
    let queue = DispatchQueue (label: "FriendsRequestDataLoadQueue", qos: .userInteractive)
    let dispatchGroup = DispatchGroup ()
    func getFriendsList () {
        var friendsItems:[FriendsRequest.Items]?
        queue.async(group: dispatchGroup) {
            let url = self.requestManager.vkRequestUrl(path: .friendsGet,queryItems: [
                URLQueryItem.init(name: "fields", value: "city,photo_100"),
                URLQueryItem.init(name: "order", value: "hints")
            ])
            self.dispatchGroup.enter()
            let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
                guard let data = data else { return self.dispatchGroup.leave() }
                let friends = try? JSONDecoder().decode(UserFriends.self, from: data)
                friendsItems = friends?.response.items
                self.dispatchGroup.leave()
            }
            task.resume()
        }
        self.dispatchGroup.notify(queue: self.queue) {
            if let items = friendsItems {
                self.countCheck(friendCount: items.count)
                items.forEach { item in
                    let friend = FriendsRealmEntity()
                    friend.name = "\(item.first_name) \(item.last_name)"
                    friend.city = "\(item.city?.title ?? "")"
                    friend.id = item.id
                    friend.photo = item.photo_100
                    self.saveFriendsData(friend: friend)
                }
            } else {
                print ("Wrong JSON")
            }
        }
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
    
    func countCheck (friendCount:Int) {
        do {
            let realm = try Realm ()
            let obj = realm.objects(FriendsRealmEntity.self)
            if friendCount < obj.count {
                realm.beginWrite()
                realm.delete(obj)
                try realm.commitWrite()
            }
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func saveFriendsData (friend: FriendsRealmEntity) {
        do {
            let realm = try Realm ()
            try realm.write () {
                realm.add(friend, update: .modified)
            }
        } catch {
            print (error.localizedDescription)
        }
    }
}

