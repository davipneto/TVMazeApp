//
//  SeriesListTableViewCell.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import UIKit
import SDWebImage

class ShowListTableViewCell: UITableViewCell {
    static let identifier = "showListCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setData(_ show: Show) {
        if let url = URL(string: show.mediumImageUrl) {
            posterImageView.sd_setImage(with: url)
        }
        titleLabel.text = show.name
    }
}
