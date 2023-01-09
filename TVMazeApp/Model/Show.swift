//
//  Show.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import Foundation
import SwiftyJSON

struct Show {
    var id: Int
    var name: String
    var mediumImageUrl: String
    var originalImageUrl: String
    var genres: [String]
    var scheduleDays: [String]
    var scheduleTime: String
    var summary: String
    
    init(from json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        mediumImageUrl = json["image"]["medium"].stringValue
        originalImageUrl = json["image"]["original"].stringValue
        genres = json["genres"].arrayObject as? [String] ?? []
        scheduleDays = json["schedule"]["days"].arrayObject as? [String] ?? []
        scheduleTime = json["schedule"]["time"].stringValue
        
        let summaryHtml = json["summary"].stringValue
        let summaryData = Data(summaryHtml.utf8)
        let attributtedString = (try? NSAttributedString(data: summaryData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)) ?? NSAttributedString(string: "")
        summary = attributtedString.string
    }
}
