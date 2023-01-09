//
//  EpisodeDetailsViewController.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 09/01/23.
//

import UIKit
import SDWebImage

class EpisodeDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let viewModel: EpisodeDetailsViewModel
    
    init(viewModel: EpisodeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "EpisodeDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.showName
        setupNavigation()
        setData()
    }
    
    private func setupNavigation() {
        let closeButton = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        navigationItem.setLeftBarButton(closeButton, animated: false)
    }
    
    private func setData() {
        let episode = viewModel.episode
        if let imageUrlString = episode.originalImageUrl,
           let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        }
        episodeNumberLabel.text = "S\(episode.season.formatWithTwoDigits) | E\(episode.number)"
        nameLabel.text = episode.name
        summaryLabel.text = episode.summary
    }
}

class EpisodeDetailsViewModel {
    var episode: Episode
    var showName: String
    
    init(episode: Episode, showName: String) {
        self.episode = episode
        self.showName = showName
    }
}
