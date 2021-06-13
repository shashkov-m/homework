import Foundation
import RealmSwift
class NewsfeedRequest {
    let requestManager = RequestManager()
    let queue = DispatchQueue (label: "NewsfeedQueue", qos: .utility)
    let dispatchGroup = DispatchGroup ()
    
    func getNewsfeed () {
        var dataResponce:NewsfeedRequest.Response?
        queue.async (group: dispatchGroup) {
            let url = self.requestManager.vkRequestUrl(path: .newsFeedGet,queryItems: [
                URLQueryItem.init(name: "filters", value: "post")
            ])
            self.dispatchGroup.enter()
            let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
                guard let data = data else {return self.dispatchGroup.leave()}
                let newsfeed = try? JSONDecoder().decode(Newsfeed.self, from: data)
                dataResponce = newsfeed?.response
                print (data )
                self.dispatchGroup.leave()
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: queue) {
            if let response = dataResponce {
                self.deleteNewsfeed()
                response.items?.forEach() { item in
                    guard item.marked_as_ads == 0 else {return}
                    let news = NewsfeedRealmEntuty ()
                    news.id = abs(item.source_id ?? 0)
                    news.date = item.date ?? 0
                    news.text = item.text
                    news.marked_as_ads = item.marked_as_ads ?? 0
                    news.likes = item.likes?.count ?? 0
                    news.user_likes = item.likes?.user_likes ?? 0
                    news.comments = item.comments?.count ?? 0
                    news.reposts = item.reposts?.count ?? 0
                    news.views = item.views?.count ?? 0
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
                    self.saveNewsData(news: news)
                }
                response.groups?.forEach() {item in
                    let group = NewsfeedRealmOwner ()
                    group.id = item.id
                    group.name = item.name
                    group.photo = item.photo_50
                    self.saveOwnerData(owner: group)
                }
                response.profiles?.forEach() {item in
                    let profile = NewsfeedRealmOwner ()
                    profile.id = item.id
                    profile.name = "\(item.first_name) \(item.last_name ?? "")"
                    profile.photo = item.photo_50
                    self.saveOwnerData(owner: profile)
                }
            } else {
                print ("Wrong JSON")
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
    //    struct Video:Codable {
    //        let duration:Int
    //
    //    }
    //    struct Link:Codable {
    //
    //    }
}

extension NewsfeedRequest {
    func saveNewsData (news:NewsfeedRealmEntuty) {
        do {
            let realm = try Realm ()
            try realm.write {
                realm.add(news)
            }
        } catch {
            print (error)
        }
    }
    
    func deleteNewsfeed () {
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
    
    func saveOwnerData (owner:NewsfeedRealmOwner) {
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
