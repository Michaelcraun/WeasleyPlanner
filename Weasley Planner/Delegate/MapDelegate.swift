//
//  MapDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/13/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import MapKit

class MapDelegate: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var delegate: UIViewController?
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    func checkLocationAuthStatus() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UserAnnotaion {
            let annotationView = annotation.user.annotationViewForUser()
            return annotationView
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        if let main = delegate as? MainVC {
            if main.mapIsCenteredOnCurrentUser { centerMapOnLocation(userLocation.coordinate) }
        }
    }
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        if let main = delegate as? MainVC {
            main.mapView.setRegion(coordinateRegion, animated: true)
            main.mapView.showsUserLocation = true
        }
    }
}
