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
    var userLetter:Character {
        get {
            return userName.first!
        }
    }
}

var friendList = [UserModel(userName: "Maxim Maximov", userCity: "Moscow"), UserModel (userName: "Alex Alexeev", userCity: "Omsk"), UserModel(userName: "Sergey Sergeev", userCity: "Volgograd"), UserModel (userName: "Andrey Andreev", userCity: "Kiev"),UserModel (userName: "Pavel Pavlov", userCity: "Sochi"), UserModel (userName: "Anton Antonov", userCity: "Saratov"), UserModel(userName: "Denis Denisov", userCity: "Rostov on Don"),UserModel(userName: "Мария Петрова", userCity: "Ufa")]
enum CommunityType {
    case Science, Music, Photography, Group, Design, Finance
}

struct CommunityModel {
    var communityName:String
    var communityType:CommunityType
}

var communityList = [CommunityModel (communityName: "IOS", communityType: .Science), CommunityModel (communityName: "Spotify", communityType: .Music), CommunityModel(communityName: "Invests", communityType: .Finance), CommunityModel (communityName: "Photoshop", communityType: .Design)]

extension CommunityModel:Equatable {
    static func == (lhs: CommunityModel, rhs: CommunityModel) -> Bool {
        return
            lhs.communityName == rhs.communityName &&
            lhs.communityType == rhs.communityType

    }
}

//let userPhotos:[UIImage] = [#imageLiteral(resourceName: "PKJHwd"),#imageLiteral(resourceName: "d0311cd8-0115-11e7-a59f-6e714efd800d.800x600"),#imageLiteral(resourceName: "photo_2021-04-01 13.27.34"),#imageLiteral(resourceName: "photo_2021-04-01 13.27.41"),#imageLiteral(resourceName: "photo_2021-04-02 10.13.36")]

var userNameChar:[Character] = []
func letterCount () {
    defer { userNameChar.sort() }
    for i in 0 ..< friendList.count {
        guard friendList [i].userName != "" else { continue }
        let char:Character = friendList [i].userLetter
        if !userNameChar.contains(char) {
            userNameChar.append(char)
        }
        else { continue }
    }
}

let userDictionary = Dictionary(grouping: friendList, by: { $0.userLetter })
//let intIndex = 1
//let index = userDictionary.index (userDictionary.startIndex, offsetBy: intIndex)
let sortedUserDictionary = userDictionary.sorted {
    $0.key < $1.key
}


//var selectedPhoto:Int = 0
