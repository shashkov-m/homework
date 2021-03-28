//
//  File.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 07.03.2021.
//

import UIKit

struct UserModel {

    var userName:String
    var userCity:String
}

var friendList = [UserModel(userName: "Maxim Maximov", userCity: "Moscow"), UserModel(userName: "Sergey Sergeevich", userCity: "Volgograd")]

enum communityType {
    case Science, Music, Photography, Group, Design, Finance
}

struct CommunityModel {
    var communityName:String
    var communityType:communityType
}

var communityList = [CommunityModel (communityName: "IOS", communityType: .Science), CommunityModel (communityName: "Spotify", communityType: .Music), CommunityModel(communityName: "Invests", communityType: .Finance), CommunityModel (communityName: "Photoshop", communityType: .Design)]

extension CommunityModel:Equatable {
    static func == (lhs: CommunityModel, rhs: CommunityModel) -> Bool {
        return
            lhs.communityName == rhs.communityName &&
            lhs.communityType == rhs.communityType
        
    }
}

let userPhotos:[UIImage] = [#imageLiteral(resourceName: "PKJHwd"),#imageLiteral(resourceName: "d0311cd8-0115-11e7-a59f-6e714efd800d.800x600")]
