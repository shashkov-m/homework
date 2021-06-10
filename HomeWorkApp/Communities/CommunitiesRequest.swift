import UIKit
import RealmSwift
class CommunitiesRequest {
    let requestManager = RequestManager ()
    let queue = DispatchQueue (label: "CommunitiesRequestQueue", qos: .utility, attributes: .concurrent)
    let dispatchGroup = DispatchGroup ()
    
    func getGroupsList () {
        var groups:CommunitiesRequest.UserGroups?
        queue.async (group: dispatchGroup) { [weak self] in
            let url = self?.requestManager.vkRequestUrl(path: .groupsGet, queryItems: [
                URLQueryItem.init(name: "extended", value: "1"),
                URLQueryItem.init(name: "fields", value: "activity")
            ])
            self?.dispatchGroup.enter()
            let task = Session.session.urlSession.dataTask(with: url!) {data, responce, error in
                guard let data = data else {return}
                groups = try? JSONDecoder().decode(UserGroups.self, from: data)
                self?.dispatchGroup.leave()
            }
            task.resume()
        }
        dispatchGroup.notify(queue: queue) {
            if let items = groups?.response.items {
                self.countCheck (communitiesCount: items.count)
                items.forEach() {item in
                    let community = CommunitiesRealmEntity ()
                    community.id = item.id
                    community.name = item.name
                    community.type = item.activity
                    community.photo = item.photo_50
                    self.saveCommunitiesData(community: community)
                }
            } else {
                print ("Wrong JSON")
            }
        }
    }
}
extension CommunitiesRequest {
    
    struct UserGroups:Decodable {
        let response: Response
    }
    struct Response:Decodable {
        let count:Int
        let items:[Items]
    }
    struct Items:Decodable {
        let id:Int
        let name:String
        let activity:String?
        let photo_50:String
    }
    struct Groups {
        let name:String
        let id:Int
        let type:String
        let photo:UIImage
    }
}

extension CommunitiesRequest {
    func countCheck (communitiesCount:Int) {
        do {
            let realm = try Realm ()
            let obj = realm.objects(CommunitiesRealmEntity.self)
            if communitiesCount < obj.count {
                realm.beginWrite()
                realm.delete(obj)
                try realm.commitWrite()
            }
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func saveCommunitiesData (community: CommunitiesRealmEntity) {
        do {
            let realm = try Realm ()
            try realm.write() {
                realm.add(community, update: .modified)
            }
        } catch {
            print (error.localizedDescription)
        }
    }
}
