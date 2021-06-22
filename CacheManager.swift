//
//  CacheManager.swift
//  HomeWorkApp
//
//  Created by 18261451 on 19.06.2021.
//

import Foundation

class Cache {
    func cashes () {
    let cashesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        print (cashesDirectory)
    }
}
