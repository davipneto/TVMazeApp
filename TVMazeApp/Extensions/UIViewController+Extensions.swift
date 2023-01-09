//
//  UIViewController+Extensions.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 08/01/23.
//

import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func showLoadingView() {
        let navigationView = navigationController?.view
        LoadingOverlay.shared.showOverlay(view: navigationView ?? view)
    }
    
    func hideLoadingView() {
        LoadingOverlay.shared.hideOverlayView()
    }
}
