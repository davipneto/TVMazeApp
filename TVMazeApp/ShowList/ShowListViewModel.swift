//
//  ShowListViewModel.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import RxSwift
import RxCocoa
import SwiftyJSON

class ShowListViewModel {
    let disposeBag = DisposeBag()
    
    var allShows = [Show]() {
        didSet {
            filteredShows = allShows
        }
    }
    var filteredShows = [Show]()
    var getNextShowsPage = PublishSubject<Int>()
    
    func fetchShows() {
        getNextShowsPage.onNext(0)
    }
    
    func fetchShowsPage(page: Int) -> Observable<[Show]> {
        return ShowApi.getShows(page: page)
            .catch({ error in
                if error.asAFError?.responseCode == 404 {
                    self.getNextShowsPage.onCompleted()
                    return Observable.empty()
                }
                return Observable.error(error)
            })
            .do(onNext: { result in
                print("didFinished page \(page)")
                result.isEmpty ? self.getNextShowsPage.onCompleted() : self.getNextShowsPage.onNext(page + 1)
            })
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
