//
//  MapDelegate.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/13/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation
import MapKit

/// Map Manager for MKMapViews
class MapDelegate: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    /// The UIViewController the MapDelegate belongs to
    var delegate: UIViewController?
    var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1000
    
    /// Checks if user has authorized use of location services
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
    
    /// Centers the map on a specific coordinate with a region of 2000 by 2000 meters.
    /// - parameter coordinate: The CLLocationCoordinate2D that the map should focus on.
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        if let main = delegate as? MainVC {
            main.familyMap.setRegion(coordinateRegion, animated: true)
            main.familyMap.showsUserLocation = true
        }
    }
    
     /// Zooms out the map to show all annotations on the map view with a region of 2000 by 2000 meters.
     /// - parameter mapView: The MKMapView annotations are displayed on.
    func zoom(toFitAnnotationOn mapView: MKMapView) {
        if mapView.annotations.count == 0 { return }
        
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation in mapView.annotations {
            topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
            bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
        }
        
        let latitude = topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5
        let longitude = topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let latitudeDelta = fabs((topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 2.0)
        let longitudeDelta = fabs((bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2.0)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        var region = MKCoordinateRegion(center: center, span: span)
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UserAnnotaion {
            let annotationView = annotation.user.annotationViewForUser()
            return annotationView
        }
        return nil
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        if let main = delegate as? MainVC {
            main.updateUserLocation(userLocation)
            if main.mapIsCenteredOnCurrentUser {
                centerMapOnLocation(userLocation.coordinate)
            } else {
                if let coordinate = main.userToCenterMapOn?.coordinate {
                    centerMapOnLocation(coordinate)
                }
            }
        }
    }
}
