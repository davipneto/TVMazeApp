//
//  ShowListApi.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import Alamofire
import RxSwift
import SwiftyJSON

class ShowApi {
    static func getShows(page: Int) -> Observable<[Show]> {
        return ApiRequest.call(path: "https://api.tvmaze.com/shows?page=\(page)")
            .map { json in
                let array = json.arrayValue
                let shows = array.map { Show(from: $0) }
                try? Database.saveShows(shows)
                return shows
            }
    }
    
    static func getShowEpisodes(showId: Int) -> Observable<[Episode]> {
        return ApiRequest.call(path: "https://api.tvmaze.com/shows/\(showId)/episodes")
            .map { json in
                let array = json.arrayValue
                print(array)
                return array.map { Episode(from: $0) }
            }
    }
}
