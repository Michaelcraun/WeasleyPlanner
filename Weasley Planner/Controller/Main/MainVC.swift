//
//  MainVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import MapKit

class MainVC: UIViewController {
    //MARK: UI Variables
    let titleBar = TitleBar()
    let mapView = MKMapView()
    let familyTable = UITableView()
    lazy var slideInTransitionManager = SlideInPresentationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        if DataHandler.instance.segueIdentifier != nil {
            loadNewController()
        }
    }
    
    func loadNewController() {
        switch DataHandler.instance.segueIdentifier {
        case Controller.calendar.segueIdentifier:
            break
        case Controller.choreChart.segueIdentifier:
            break
        case Controller.mealPlanner.segueIdentifier:
            break
        case Controller.shoppingList.segueIdentifier:
            break
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSidePane" {
            if let destination = segue.destination as? SidePaneVC {
                slideInTransitionManager.direction = .left
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
            }
        }
    }
}

