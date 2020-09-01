//
//  Post.swift
//  TestWhitePixel
//
//  Created by DoanDuyPhuong on 8/30/20.
//  Copyright © 2020 prox.com. All rights reserved.
//

import Foundation
import ObjectMapper

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

class Post2: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        userId <- map["userId"]
    }
    
    private var id: Int = 0
    private var title: String = ""
    private var body: String = ""
    private var userId: String = ""
}
