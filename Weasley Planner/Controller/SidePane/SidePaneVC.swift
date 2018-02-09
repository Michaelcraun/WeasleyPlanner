//
//  SidePaneVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class SidePaneVC: UIViewController {
    let vcTable = UITableView()
    let bottomPane = UIView()
    let settingsButton = UIButton()
    let selfPane = UserPane()
    let familyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func sidePaneButtonPressed(_ sender: UIButton) {
        
    }
}
