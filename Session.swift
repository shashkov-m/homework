//
//  Session.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 16.04.2021.
//

import Foundation


class Session {
    
    static let session = Session ()
    
    private init () { }
    
    var token:String = ""
    var userId:String = ""
    
    let urlSession = URLSession (configuration: .default)
}
