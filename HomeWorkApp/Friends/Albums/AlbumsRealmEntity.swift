//
//  AlbumsRealmEntity.swift
//  HomeWorkApp
//
//  Created by Max on 08.05.2021.
//

import Foundation
import RealmSwift
class AlbumsRealmEntity:Object {
    @objc dynamic var name:String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var photo:String = ""
    @objc dynamic var owner_id:Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }
}
