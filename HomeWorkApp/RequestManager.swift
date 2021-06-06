//
//  RequestManager.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 22.04.2021.
//

import UIKit

class RequestManager {
    
    enum path:String {
        case friendsGet = "/method/friends.get"
        case photosGet = "/method/photos.get"
        case groupsGet = "/method/groups.get"
        case albumsGet = "/method/photos.getAlbums"
        case newsFeedGet = "/method/newsfeed.get"
    }
    
    func vkRequestUrl (path: path, queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents ()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = path.rawValue
        urlComponents.queryItems = queryItems
        urlComponents.queryItems?.append(URLQueryItem.init(name: "access_token", value: "\(Session.session.token)"))
        urlComponents.queryItems?.append(URLQueryItem.init(name: "v", value: "5.130"))
        return urlComponents.url!
    }
}

