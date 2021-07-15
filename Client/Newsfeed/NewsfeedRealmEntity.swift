import RealmSwift
class NewsfeedRealmEntuty:Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var date:Int = 0
    @objc dynamic var text:String?
    @objc dynamic var marked_as_ads:Int = 0
    @objc dynamic var likes:Int = 0
    @objc dynamic var comments:Int = 0
    @objc dynamic var views:Int = 0
    @objc dynamic var reposts:Int = 0
    @objc dynamic var user_likes:Int = 0
    var attachments = List <NewsfeedRealmAttachment> ()
    
    convenience init (item: NewsfeedRequest.Items) {
        self.init ()
        self.id = abs(item.source_id ?? 0)
        self.date = item.date ?? 0
        self.text = item.text
        self.marked_as_ads = item.marked_as_ads ?? 0
        self.likes = item.likes?.count ?? 0
        self.user_likes = item.likes?.user_likes ?? 0
        self.comments = item.comments?.count ?? 0
        self.reposts = item.reposts?.count ?? 0
        self.views = item.views?.count ?? 0
    }
}

class NewsfeedRealmAttachment:Object {
    @objc dynamic var type:String = ""
    @objc dynamic var source:String?
    @objc dynamic var preview:String?
}

class NewsfeedRealmOwner:Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var photo:String = ""
    
    convenience init (item: NewsfeedRequest.Groups) {
        self.init()
        self.id = item.id
        self.name = item.name
        self.photo = item.photo_50
    }
    
    convenience init (item: NewsfeedRequest.Profiles) {
        self.init()
        self.id = item.id
        self.name = "\(item.first_name) \(item.last_name ?? "")"
        self.photo = item.photo_50
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
