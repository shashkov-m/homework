import RealmSwift
class FriendsRealmEntity:Object {
    @objc dynamic var name:String = ""
    @objc dynamic var city:String?
    @objc dynamic var id:Int = 0
    @objc dynamic var photo:String = ""
}
