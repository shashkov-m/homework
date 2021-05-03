//
//  CommunitiesRequest.swift
//  HomeWorkApp
//
//  Created by Max on 28.04.2021.
//

import UIKit

class CommunitiesRequest {
    
    let requestManager = RequestManager ()
    
    struct UserGroups:Decodable {
        let response: Response
    }
    struct Response:Decodable {
        let count:Int
        let items:[Items]
    }
    struct Items:Decodable {
        let id:Int
        let name:String
        let activity:String?
        let photo_50:String
    }
    
    struct Groups {
        let name:String
        let id:Int
        let type:String
        let photo:UIImage
    }
    
    var groupsList = [Groups]()
    
    func getGroupsList () {
        let url = requestManager.vkRequestUrl(path: .groupsGet, queryItems: [
            URLQueryItem.init(name: "access_token", value: "\(Session.session.token)"),
            URLQueryItem.init(name: "extended", value: "1"),
            URLQueryItem.init(name: "fields", value: "activity"),
            URLQueryItem.init(name: "v", value: "5.130")
        ])
        let task = Session.session.urlSession.dataTask(with: url) {data, responce, error in
            guard let data = data else {return}
            let groups = try? JSONDecoder().decode(UserGroups.self, from: data)
            if let items = groups?.response.items {
                
                for i in 0 ..< items.count {
                    let imageTask = Session.session.urlSession.dataTask(with: URL(string: items[i].photo_50)!) { (imageData, _, _) in
                        if let imageData = imageData {
                            let image = UIImage(data: imageData)!
                            self.groupsList.append(Groups(name: items[i].name, id: items[i].id, type: items[i].activity ?? "" , photo: image))
                        }
                    }
                    imageTask.resume()
                }
            } else {
                print ("Wrong JSON")
            }
        }
        task.resume()
    }
}
