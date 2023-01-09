//
//  ShowDetailsViewModel.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import RxSwift
import RxCocoa

class SeasonExpandable {
    var season: Season
    var isExpanded: Bool = false
    
    init(season: Season) {
        self.season = season
    }
}

class ShowDetailsViewModel {
    var show: Show
    var seasonItems = [SeasonExpandable]()
    
    init(show: Show) {
        self.show = show
    }
    
    func getGenres() -> String {
        return show.genres.joined(separator: " • ")
    }
    
    func getScheduleDays() -> String {
        return show.scheduleDays.joined(separator: "\n")
    }
    
    func calculateNavigationBarAlpha(heightOffset: CGFloat, nameLabelOriginY: CGFloat, topBarHeight: CGFloat, nameLabelHeight: CGFloat) -> CGFloat {
        guard heightOffset > nameLabelOriginY - topBarHeight
        else { return 0 }
        
        let proportion = (heightOffset - nameLabelOriginY + topBarHeight) / nameLabelHeight
        return proportion > 1 ? 1 : proportion
    }
    
    func fetchEpisodes() -> Observable<Void> {
        return ShowApi.getShowEpisodes(showId: show.id)
//            .map { self.episodes.accept($0) }
            .map { [weak self] episodes in
                let dictionary = Dictionary(grouping: episodes, by: { $0.season })
                let seasonExpandableItems = dictionary.map { seasonNumber, episodes in
                    let season = Season(number: seasonNumber, episodes: episodes)
                    return SeasonExpandable(season: season)
                }
                self?.seasonItems = seasonExpandableItems.sorted { $0.season.number < $1.season.number }
            }
    }
}
