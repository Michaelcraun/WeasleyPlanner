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
    let familyTable = UITableView()
    let locationManager = CLLocationManager()
    lazy var slideInTransitionManager = SlideInPresentationManager()
    
    //MARK: Data Variables
    let regionRadius: CLLocationDistance = 1000
    var needsToSegue = false
    var mapIsCenteredOnCurrentUser = true
    var selfUser = User()
    var familyUsers = [User]() {
        didSet {
            familyTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        checkLocationAuthStatus()
        
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        observeCurrentUser()
        
        if DataHandler.instance.currentUserID == nil {
            familyUsers = []
        }
        
        if DataHandler.instance.segueIdentifier != nil {
            needsToSegue = true
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
                
                if familyUsers.count > 0 { destination.user = familyUsers[0] }
            }
        } else if segue.identifier == Controller.calendar.segueIdentifier {
            if let destination = segue.destination as? CalendarVC {
                slideInTransitionManager.direction = .right
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
            }
        } else if segue.identifier == Controller.choreChart.segueIdentifier {
            if let destination = segue.destination as? ChoreChartVC {
                slideInTransitionManager.direction = .right
                slideInTransitionManager.disableCompactHeight = false
                destination.transitioningDelegate = slideInTransitionManager
                destination.modalPresentationStyle = .custom
            }
        } else if segue.identifier == Controller.mealPlanner.segueIdentifier {
            if let destination = segue.destination as? MealPlannerVC {
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
    }
}

extension MainVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        return nil
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        if mapIsCenteredOnCurrentUser { centerMapOnLocation(userLocation.coordinate) }
        updateUserLocation(with: userLocation)
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }
}
