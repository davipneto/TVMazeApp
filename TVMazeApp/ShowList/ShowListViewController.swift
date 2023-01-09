//
//  SeriesListViewController.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RealmSwift

class ShowListViewController: UITableViewController {
    let viewModel = ShowListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Shows"
        navigationItem.backButtonDisplayMode = .minimal
        setupTableView()
        setupSearchBar()
        bindGetShowsPage()
        loadShows()
    }
    
    private func loadShows() {
        showLoadingView()
        viewModel.fetchShows()
    }
    
    private func bindGetShowsPage() {
        viewModel.getNextShowsPage
            .flatMap { page in
                print("will try page \(page)")
                return self.viewModel.fetchShowsPage(page: page)
            }
            .subscribe(onNext: { _ in
                print("successful")
            }, onError: { error in
                print("deu erro")
            }, onCompleted: {
                print("acabou!!")
                self.hideLoadingView()
                guard let shows = try? Realm().objects(Show.self) else { return }
                print(shows.count)
            })
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "ShowListTableViewCell", bundle: nil), forCellReuseIdentifier: ShowListTableViewCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowListTableViewCell.identifier) as? ShowListTableViewCell,
              indexPath.row < viewModel.filteredShows.count
        else {
            return UITableViewCell()
        }
        
        let show = viewModel.filteredShows[indexPath.row]
        cell.setData(show)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.filteredShows.count else { return }
        let show = viewModel.filteredShows[indexPath.row]
        let showDetailsViewModel = ShowDetailsViewModel(show: show)
        let showDetailsViewController = ShowDetailsViewController(viewModel: showDetailsViewModel)
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ShowListViewController: UISearchResultsUpdating {
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.filterShows(searchText: text)
        tableView.reloadData()
    }
}
