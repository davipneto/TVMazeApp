//
//  Show.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Show: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var mediumImageUrl: String
    @Persisted var originalImageUrl: String
    @Persisted var genres: List<String> = List()
    @Persisted var scheduleDays: List<String> = List()
    @Persisted var scheduleTime: String
    @Persisted var summary: String
    
    convenience init(from json: JSON) {
        self.init()
        id = json["id"].intValue
        name = json["name"].stringValue
        mediumImageUrl = json["image"]["medium"].stringValue
        originalImageUrl = json["image"]["original"].stringValue
        scheduleTime = json["schedule"]["time"].stringValue
        let summaryHtml = json["summary"].stringValue
        let summaryData = Data(summaryHtml.utf8)
        let attributtedString = (try? NSAttributedString(data: summaryData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)) ?? NSAttributedString(string: "")
        summary = attributtedString.string
        
        let genres = json["genres"].arrayObject as? [String] ?? []
        let scheduleDays = json["schedule"]["days"].arrayObject as? [String] ?? []
        self.genres.append(objectsIn: genres)
        self.scheduleDays.append(objectsIn: scheduleDays)
    }
}
