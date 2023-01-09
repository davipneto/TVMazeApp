//
//  Int+Formatter.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 09/01/23.
//

import Foundation

extension Int {
    var formatWithTwoDigits: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: self as NSNumber) ?? "\(self)"
    }
}
