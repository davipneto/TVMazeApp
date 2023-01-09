//
//  UIView+Constraints.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 09/01/23.
//

import UIKit

extension UIView {
    func pinToSuperview() {
        prepareForConstraints()
        guard let superview = superview else { return }
        let constraints = [
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func centerOnSuperview() {
        centerXSuperview()
        centerYSuperview()
    }
    
    func centerXSuperview() {
        guard let superview = superview else { return }
        prepareForConstraints()
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    
    func centerYSuperview() {
        guard let superview = superview else { return }
        prepareForConstraints()
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    
    func prepareForConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
