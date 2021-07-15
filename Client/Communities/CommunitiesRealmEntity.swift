import Foundation
import RealmSwift

class CommunitiesRealmEntity:Object {
    
    @objc dynamic var name:String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var type:String?
    @objc dynamic var photo:String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
