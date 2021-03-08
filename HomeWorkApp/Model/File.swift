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
