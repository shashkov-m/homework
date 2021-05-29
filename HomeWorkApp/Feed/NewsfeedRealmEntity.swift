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
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
