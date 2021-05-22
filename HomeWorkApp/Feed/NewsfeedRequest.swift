import Foundation
import RealmSwift
class NewsfeedRequest {
    let requestManager = RequestManager()
    
    func getNewsfeed () {
        let url = requestManager.vkRequestUrl(path: .newsFeedGet,queryItems: [
            URLQueryItem.init(name: "filters", value: "post")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            let newsfeed = try? JSONDecoder().decode(Newsfeed.self, from: data)
            if let response = newsfeed?.response {
                self.deleteNewsfeed()
                response.items.forEach() { item in
                    guard item.marked_as_ads == 0 else {return}
                    let news = NewsfeedRealmEntuty ()
                    news.id = abs(item.source_id)
                    news.date = item.date
                    news.text = item.text
                    news.marked_as_ads = item.marked_as_ads
                    news.likes = item.likes.count
                    news.user_likes = item.likes.user_likes
                    news.comments = item.comments.count
                    news.reposts = item.reposts.count
                    news.views = item.views.count
                    if let attachments = item.attachments {
                        for i in 0 ..< attachments.count {
                            let attach = NewsfeedRealmAttachment ()
                            attach.type = attachments[i].type
                            switch attach.type {
                            case "photo":
                                attachments[i].photo?.sizes.forEach { size in
                                    guard size.type == "q" else { return }
                                    attach.source = size.url
                                }
                            case "doc":
                                attach.source = attachments[i].doc?.url
                            default:
                                break
                            }
                            

                            news.attachments.append(attach)
                        }
                    }
                    self.saveNewsData(news: news)
                }
                response.groups.forEach() {item in
                    let group = NewsfeedRealmOwner ()
                    group.id = item.id
                    group.name = item.name
                    group.photo = item.photo_50
                    self.saveOwnerData(owner: group)
                }
                response.profiles.forEach() {item in
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
        task.resume()
    }
}

extension NewsfeedRequest {
    struct Newsfeed:Codable {
        let response:Response
    }
    struct Response:Codable {
        let items:[Items]
        let profiles:[Profiles]
        let groups:[Groups]
        let next_from:String
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
        let source_id:Int
        let date:Int
        let text:String?
        let marked_as_ads:Int
        let attachments:[Attachments]?
        let comments:Comments
        let likes:Likes
        let reposts:Reposts
        let views:Views
    }
    struct Attachments:Codable {
        let type:String
        let photo:Photo?
        let doc:Doc?
        //let video:Video?
        // let link:Link?
    }
    struct Photo:Codable {
        let owner_id:Int
        let sizes:[Sizes]
    }
    struct Doc:Codable {
        let url:String
    }
    struct Sizes:Codable{
        let type:String
        let url:String
    }
    
    struct Comments:Codable {
        let count:Int
    }
    struct Likes:Codable {
        let count:Int
        let user_likes:Int
    }
    struct Reposts:Codable {
        let count:Int
    }
    struct Views:Codable {
        let count:Int
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
