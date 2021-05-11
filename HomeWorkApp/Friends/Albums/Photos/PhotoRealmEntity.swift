//
//  PhotoRealmEntity.swift
//  HomeWorkApp
//
//  Created by Max on 09.05.2021.
//

import Foundation
import RealmSwift

class PhotoRealmEntity:Object {
    
    @objc dynamic var album_id:Int = 0
    @objc dynamic var photo:String = ""
    @objc dynamic var owner_id:Int = 0
    
    override class func primaryKey() -> String? {
        return "photo"
    }
}
