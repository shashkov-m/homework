import UIKit
import RealmSwift
import PromiseKit
class FriendsRequest {
    private let requestManager = RequestManager ()
    private let queue:DispatchQueue = DispatchQueue (label: "FriendsRequestQueue", qos: .utility, attributes: .concurrent)
    
    private func getFriendsListData () -> Promise <Data> {
        
        let url = requestManager.vkRequestUrl(path: .friendsGet,queryItems: [
            URLQueryItem.init(name: "fields", value: "city,photo_100"),
            URLQueryItem.init(name: "order", value: "hints")
        ])
        let promise = Promise<Data> { seal in
            let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
                
                if let data = data {
                    seal.resolve(.fulfilled(data))
                }
                if let error = error {
                    seal.reject(error)
                }
            }
            task.resume()
        }
        return promise
    }
    
    private func parseFriendsListData (data:Data) -> Promise <[FriendsRequest.Items]> {
        let promise = Promise <[Items]> {seal in
            let friends = try? JSONDecoder().decode(UserFriends.self, from: data)
            
            if let friendsItems = friends?.response.items {
                seal.resolve(.fulfilled(friendsItems))
            } else {
                seal.reject(PromiseError.error)
            }
        }
        return promise
    }
    
    private func saveFriendsListData (items:[Items]) {
        self.countCheck(friendCount: items.count)
        items.forEach { item in
            let friend = FriendsRealmEntity()
            friend.name = "\(item.first_name) \(item.last_name)"
            friend.city = "\(item.city?.title ?? "")"
            friend.id = item.id
            friend.photo = item.photo_100
            self.saveFriendsData(friend: friend)
        }
    }
    
    func getFriendsList () {
        firstly () {
            getFriendsListData()
        }.then (on: queue) {data in
            self.parseFriendsListData(data: data)
        }.done (on: queue) {items in
            self.saveFriendsListData(items: items)
        }.catch {error in
            print (error.localizedDescription)
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
    
    enum PromiseError:Error {
        case error
    }
}

extension FriendsRequest {
    
    private func countCheck (friendCount:Int) {
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
    
    private func saveFriendsData (friend: FriendsRealmEntity) {
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

