//
//  Photo.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    var title: String?
    var imageHref: String?
    var description: String?
    
    init(json: JSON) {
        self.title = json["title"].string
        self.imageHref = json["imageHref"].string
        self.description = json["description"].string
    }
}

/*
//Comments here: just tried to use JSONDecoder().decode(Canada.self, from: convertedData)
struct Canada: Decodable {
    let title: String
    let rows: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case title
        case rows
    }
}

struct Photo: Decodable {
    let title: String
    let imageHref: URL
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageHref
        case description
    }
}
*/
