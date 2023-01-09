//
//  ShowListViewModel.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import RxSwift
import RxCocoa

class ShowListViewModel {
    var allShows = [Show]() {
        didSet {
            filteredShows = allShows
        }
    }
    var filteredShows = [Show]()
    
    func fetchShows() -> Observable<Void> {
        return ShowApi.getShows()
            .map { [weak self] shows in
                self?.allShows = shows
            }
    }
    
    func filterShows(searchText: String) {
        guard !searchText.isEmpty else {
            filteredShows = allShows
            return
        }
        filteredShows = allShows
            .filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}
