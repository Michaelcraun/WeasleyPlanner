//
//  UIViewControllerExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/27/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayLoadingView(_ shouldDisplay: Bool) {
        if shouldDisplay {
            let loadingView: UIView = {
                let view = UIView()
                view.alpha = 0.75
                view.backgroundColor = .black
                view.tag = 1007
                
                return view
            }()
            
            let loadingIndicator: UIActivityIndicatorView = {
                let indicator = UIActivityIndicatorView()
                indicator.activityIndicatorViewStyle = .whiteLarge
                return indicator
            }()
            
            loadingView.addSubview(loadingIndicator)
            
            loadingIndicator.startAnimating()
            loadingIndicator.anchor(centerX: loadingView.centerXAnchor,
                                    centerY: loadingView.centerYAnchor)
            
            self.view.addSubview(loadingView)
            
            loadingView.fillTo(self.view)
        } else {
            for subview in self.view.subviews {
                if subview.tag == 1007 {
                    subview.fadeAlphaOut()
                }
            }
        }
    }
}
