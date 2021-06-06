import UIKit
import RealmSwift
class CommunitiesRequest {
    
    let requestManager = RequestManager ()
    
    func getGroupsList () {
        let url = requestManager.vkRequestUrl(path: .groupsGet, queryItems: [
            URLQueryItem.init(name: "extended", value: "1"),
            URLQueryItem.init(name: "fields", value: "activity")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, responce, error in
            guard let data = data else {return}
            let groups = try? JSONDecoder().decode(UserGroups.self, from: data)
            if let items = groups?.response.items {
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
        task.resume()
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
