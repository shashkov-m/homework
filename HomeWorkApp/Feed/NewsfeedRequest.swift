import Foundation
import RealmSwift
class NewsfeedRequest {
    
    private let requestManager = RequestManager()
    private let queue = DispatchQueue (label: "NewsfeedQueue", qos: .utility, attributes: .concurrent)
    private let dispatchGroup = DispatchGroup ()
    static var nextFrom:String?
    
    func getNewsfeed (startFrom:String?, completion: @escaping (Bool) -> Void) {
        var dataResponce:NewsfeedRequest.Response?
        queue.async (group: dispatchGroup) { [weak self] in
            var queryItems:[URLQueryItem] = [URLQueryItem.init(name: "filters", value: "post"), URLQueryItem.init(name: "count", value: "20")]
            if startFrom != nil {
                queryItems.append(URLQueryItem.init(name: "start_from", value: startFrom))
            }
            let url = self?.requestManager.vkRequestUrl(path: .newsFeedGet,queryItems: queryItems)
            self?.dispatchGroup.enter()
            guard let url = url else {self?.dispatchGroup.leave(); return}
            let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
                guard let data = data else {self?.dispatchGroup.leave(); return}
                let newsfeed = try? JSONDecoder().decode(Newsfeed.self, from: data)
                dataResponce = newsfeed?.response
                self?.dispatchGroup.leave()
            }
            task.resume()
        }
        dispatchGroup.notify(queue: queue) { [weak self] in
            if let response = dataResponce {
                if NewsfeedRequest.nextFrom == nil { self?.deleteNewsfeed() }
                NewsfeedRequest.nextFrom = response.next_from ?? ""
                response.items?.forEach() { item in
                    guard item.marked_as_ads == 0 else {return}
                    let news = NewsfeedRealmEntuty (item: item)
                    if let attachments = item.attachments {
                        for i in 0 ..< attachments.count {
                            let attach = NewsfeedRealmAttachment ()
                            attach.type = attachments[i].type ?? "nil"
                            switch attach.type {
                            case "photo":
                                attachments[i].photo?.sizes?.forEach { size in
                                    guard size.type == "q" else { return }
                                    attach.source = size.url
                                }
                            case "doc":
                                attach.source = attachments[i].doc?.url
                                attach.preview = attachments[i].doc?.preview?.photo?.sizes?[0].src
                            default:
                                break
                            }
                            news.attachments.append(attach)
                        }
                    }
                    self?.saveNewsData(news: news)
                }
                response.groups?.forEach() {item in
                    let group = NewsfeedRealmOwner (item: item)
                    self?.saveOwnerData(owner: group)
                }
                response.profiles?.forEach() {item in
                    let profile = NewsfeedRealmOwner (item: item)
                    self?.saveOwnerData(owner: profile)
                }
                completion (true)
            } else {
                print ("Wrong JSON")
                completion (false)
            }
        }
    }
}

extension NewsfeedRequest {
    struct Newsfeed:Codable {
        let response:Response
    }
    struct Response:Codable {
        let items:[Items]?
        let profiles:[Profiles]?
        let groups:[Groups]?
        let next_from:String?
    }
    struct Profiles:Codable {
        let id:Int
        let first_name:String
        let last_name:String?
        let photo_50:String
    }
    struct Groups:Codable {
        let id:Int
        let name:String
        let photo_50:String
        
    }
    struct Items:Codable {
        let source_id:Int?
        let date:Int?
        let text:String?
        let marked_as_ads:Int?
        let attachments:[Attachments]?
        let comments:Comments?
        let likes:Likes?
        let reposts:Reposts?
        let views:Views?
    }
    struct Attachments:Codable {
        let type:String?
        let photo:Photo?
        let doc:Doc?
        //let video:Video?
        // let link:Link?
    }
    struct Photo:Codable {
        let owner_id:Int?
        let sizes:[Sizes]?
    }
    struct Doc:Codable {
        let url:String?
        let preview:Preview?
    }
    struct Preview:Codable {
        let photo:PreviewSizes?
    }
    struct PreviewSizes:Codable {
        let sizes:[Src]?
    }
    struct Src:Codable {
        let src:String?
    }
    struct Sizes:Codable{
        let type:String?
        let url:String?
    }
    
    struct Comments:Codable {
        let count:Int?
    }
    struct Likes:Codable {
        let count:Int?
        let user_likes:Int?
    }
    struct Reposts:Codable {
        let count:Int?
    }
    struct Views:Codable {
        let count:Int?
    }
}

extension NewsfeedRequest {
    private func saveNewsData (news:NewsfeedRealmEntuty) {
        do {
            let realm = try Realm ()
            try realm.write {
                realm.add(news)
            }
        } catch {
            print (error)
        }
    }
    
    private func deleteNewsfeed () {
        do {
            let realm = try Realm ()
            let obj = realm.objects(NewsfeedRealmEntuty.self)
            let attach = realm.objects(NewsfeedRealmAttachment.self)
            if obj.count > 0 {
                try realm.write() {
                    realm.delete(obj)
                    realm.delete(attach)
                }
            }
        } catch {
            print (error)
        }
    }
    
    private func saveOwnerData (owner:NewsfeedRealmOwner) {
        do {
            let realm = try Realm ()
            try realm.write() {
                realm.add(owner, update: .modified)
            }
        } catch {
            print (error)
        }
    }
}
