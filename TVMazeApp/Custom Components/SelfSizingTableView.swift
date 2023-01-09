//
//  SelfSizingTableView.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 09/01/23.
//

import UIKit

class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = contentSize.height
        return CGSize(width: contentSize.width, height: height)
    }
}
