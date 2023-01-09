//
//  ShadowView.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import UIKit

class ShadowView: UIView {
    override public class var layerClass: Swift.AnyClass {
            return CAGradientLayer.self
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            let topColor = UIColor.black.withAlphaComponent(0.25).cgColor
            let bottomColor = UIColor.black.cgColor
            let colors: [AnyObject] = [topColor, bottomColor]
            gradientLayer.colors = colors
        }
}
