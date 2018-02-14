//
//  MainVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/8/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainVC: UIViewController {
    //MARK: UI Variables
    let titleBar = TitleBar()
    let mapView = MKMapView()
    let centerButton = UIButton()
    let familyTable = UITableView()
    lazy var slideInTransitionManager = SlideInPresentationManager()
    
    //MARK: Data Variables
    let regionRadius: CLLocationDistance = 1000
    var needsToSegue = false
    var mapIsCenteredOnCurrentUser = true
    var mapIsCenteredOnFamily = false
    var userToCenterMapOn: User?
    var selfUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager.delegate = self
        
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        if DataHandler.instance.currentUserID == nil {
            mapView.removeAnnotations(mapView.annotations)
            DataHandler.instance.familyUsers = []
            familyTable.reloadData()
            selfUser = User()
            mapIsCenteredOnCurrentUser = true
            mapIsCenteredOnFamily = false
            userToCenterMapOn = nil
            centerButton.fadeAlphaTo(0)
        } else {
            centerButton.fadeAlphaTo(1)
        }
        
        initializeCurrentUser()
        observeFamilyUsers()
        
        if DataHandler.instance.segueIdentifier != nil {
            if DataHandler.instance.segueIdentifier == Controller.main.segueIdentifier || DataHandler.instance.segueIdentifier == "dismiss" {
                DataHandler.instance.segueIdentifier = nil
            } else {
                needsToSegue = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if needsToSegue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: DataHandler.instance.segueIdentifier, sender: nil)
                
                self.needsToSegue = false
                DataHandler.instance.segueIdentifier = nil
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSidePane" {
            if let destination = segue.destination as? SidePaneVC {
                slideInTransitionManager.direction = .left
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
                
                destination.user = selfUser
            }
        } else if segue.identifier == Controller.calendar.segueIdentifier {
            if let destination = segue.destination as? CalendarVC {
                slideInTransitionManager.direction = .right
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
            }
        } else if segue.identifier == Controller.recipeList.segueIdentifier {
            if let destination = segue.destination as? RecipeListVC {
                slideInTransitionManager.direction = .right
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
            }
        } else if segue.identifier == Controller.shoppingList.segueIdentifier {
            if let destination = segue.destination as? ShoppingListVC {
                slideInTransitionManager.direction = .right
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
            }
        }
        DataHandler.instance.REF_USER.removeAllObservers()
    }
    
    @objc func centerButtonPressed(_ sender: UIButton) {
        userToCenterMapOn = nil
        
        switch sender.image(for: .normal)! {
        case #imageLiteral(resourceName: "familyIcon"):
            mapIsCenteredOnCurrentUser = false
            mapIsCenteredOnFamily = true
            centerButton.setImage(#imageLiteral(resourceName: "defaultProfileImage"), for: .normal)
            mapManager.zoom(toFitAnnotationOn: mapView)
        case #imageLiteral(resourceName: "defaultProfileImage"):
            mapIsCenteredOnCurrentUser = true
            mapIsCenteredOnFamily = false
            centerButton.setImage(#imageLiteral(resourceName: "familyIcon"), for: .normal)
            if let coordinate = mapManager.locationManager.location?.coordinate {
                mapManager.centerMapOnLocation(coordinate)
            }
        default: break
        }
    }
}
