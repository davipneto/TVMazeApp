//
//  Episode.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import SwiftyJSON

struct Episode {
    var id: Int
    var name: String
    var number: Int
    var season: Int
    var summary: String
    var mediumImageUrl: String?
    var originalImageUrl: String?
    
    init(from json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        number = json["number"].intValue
        season = json["season"].intValue
        summary = json["summary"].stringValue
        
        let imgJSON = json["image"]
        mediumImageUrl = imgJSON["medium"].string
        originalImageUrl = imgJSON["original"].string
    }
}
