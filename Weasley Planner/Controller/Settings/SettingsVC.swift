//
//  SettingsVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsVC: UIViewController {
    //MARK: UI Variables
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitleLabel.text = "Settings"
        return bar
    }()
    
    let familyButton = TextButton()
    let creditsView = UITextView()
    let locationManager = CLLocationManager()
    //TODO: Possibly allow user to set their own meal times?
    
    let familyView = UIView()
    let familyTable = UITableView()
    let saveButton = TextButton()
    
    //MARK: Data Variables
    let creditsString = "Harry P Font|_____"
    var user: User?
    var userToAddToFamily: User?
    var userToRemoveFromFamily: User?
    
    var nearbyUsers = [User]() {
        didSet {
            familyTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        
    }
    
    @objc func familyButtonPressed(_ sender: TextButton?) {
        layoutFamilyView()
        familyView.fadeAlphaTo(1)
        observeForNearbyUsers()
    }
    
    @objc func saveButtonPressed(_ sender: TextButton) {
        familyView.fadeAlphaOut()
        for subview in self.view.subviews {
            if subview.tag == 1002 {
                subview.fadeAlphaOut()
            }
        }
    }
}
