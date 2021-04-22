//
//  RequestManager.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 22.04.2021.
//

import Foundation

class RequestManager {
    
    private enum path:String {
        case friendsGet = "/method/friends.get"
        case photosGet = "/method/photos.get"
    }
    
    private func vkRequestUrl (path: path,queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents ()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = path.rawValue
        urlComponents.queryItems = queryItems
        print (urlComponents.url!)
        return urlComponents.url!
    }
    
    func getFriendsList () {
        let url = vkRequestUrl(path: .friendsGet,queryItems: [
            URLQueryItem.init(name: "access_token", value: "\(Session.session.token)"),
            URLQueryItem.init(name: "fields", value: "city,sex"),
            URLQueryItem.init(name: "v", value: "5.130")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            if let error = error {
                print (error.localizedDescription)
            }else if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
                
            }else {
                print ("No data")
            }
        }
        task.resume()
    }
    
    func getPhoto () {
        let url = vkRequestUrl(path: .photosGet,queryItems: [
            URLQueryItem.init(name: "access_token", value: "\(Session.session.token)"),
            URLQueryItem.init(name: "album_id", value: "profile"),
            URLQueryItem.init(name: "v", value: "5.130")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, response, error in
            if let error = error {
                print (error.localizedDescription)
            }else if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
                
            }else {
                print ("No data")
            }
        }
        task.resume()
    }
}

