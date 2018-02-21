//
//  UITableViewCellExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func clearCell() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
