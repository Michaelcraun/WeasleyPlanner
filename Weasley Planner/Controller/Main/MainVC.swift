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
    lazy var slideInTransitionManager = SlideInPresentationManager()
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
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
        centerMapOnUserLocation()
        
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        observeCurrentUser()
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
                
                if familyUsers.count > 0 { destination.user = familyUsers[0] }
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
        guard let location = locations.last else { return }
        updateUserLocation(with: location)
        
        centerMapOnUserLocation()
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            centerMapOnUserLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }
}
