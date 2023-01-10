//
//  ShowDetailsViewController.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class ShowDetailsViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var scheduleDaysLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerLabelsStackView: UIStackView!
    @IBOutlet weak var seasonsTableView: UITableView!
    
    let viewModel: ShowDetailsViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: ShowDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ShowDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.show.name
        navigationItem.largeTitleDisplayMode = .never
        setupScrollView()
        setupTableView()
        setData()
        getEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.subviews.first?.alpha = 1
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupTableView() {
        seasonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        seasonsTableView.isScrollEnabled = false
        seasonsTableView.dataSource = self
        seasonsTableView.delegate = self
    }

    private func setData() {
        let show = viewModel.show
        if let url = URL(string: show.originalImageUrl) {
            posterImageView.sd_setImage(with: url)
        }
        nameLabel.text = show.name
        genresLabel.text = viewModel.getGenres()
        scheduleDaysLabel.text = viewModel.getScheduleDays()
        scheduleTimeLabel.text = show.scheduleTime
        summaryLabel.text = show.summary
    }
    
    private func getEpisodes() {
        showLoadingView()
        viewModel.fetchEpisodes()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.hideLoadingView()
                self?.seasonsTableView.reloadData()
            }, onError: { [weak self] error in
                self?.hideLoadingView()
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

extension ShowDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = viewModel.calculateNavigationBarAlpha(
            heightOffset: scrollView.contentOffset.y,
            nameLabelOriginY: headerLabelsStackView.frame.origin.y,
            topBarHeight: topbarHeight,
            nameLabelHeight: nameLabel.bounds.height
        )
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.subviews.first?.alpha = alpha
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label.withAlphaComponent(alpha)]
    }
}


extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.seasonItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let seasonExpandable = viewModel.seasonItems[section]
        return seasonExpandable.isExpanded ? seasonExpandable.season.episodes.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        let episode = viewModel.seasonItems[indexPath.section].season.episodes[indexPath.row]
        var cellContentConfiguration = cell.defaultContentConfiguration()
        cellContentConfiguration.text = "S\(episode.season.formatWithTwoDigits) | E\(episode.number.formatWithTwoDigits)"
        cellContentConfiguration.secondaryText = episode.name
        cell.contentConfiguration = cellContentConfiguration
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var config = UIButton.Configuration.gray()
        config.imagePlacement = .trailing
        config.baseForegroundColor = UIColor.label
        let button = UIButton(configuration: config)
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.seasonItems[section].isExpanded.toggle()
                tableView.reloadData()
            })
            .disposed(by: disposeBag)
        let season = "Season \(viewModel.seasonItems[section].season.number)"
        button.setTitle(season, for: .normal)
        button.setImage(UIImage.init(systemName: self.viewModel.seasonItems[section].isExpanded ? "chevron.up" : "chevron.down"), for: .normal)
        button.contentHorizontalAlignment = .fill
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = viewModel.seasonItems[indexPath.section].season.episodes[indexPath.row]
        let episodeDetailsViewModel = EpisodeDetailsViewModel(episode: episode, showName: viewModel.show.name)
        let episodeDetailsViewController = EpisodeDetailsViewController(viewModel: episodeDetailsViewModel)
        let navigationController = UINavigationController(rootViewController: episodeDetailsViewController)
        present(navigationController, animated: true)
    }
}
