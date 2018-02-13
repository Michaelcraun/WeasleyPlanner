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
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        if let main = delegate as? MainVC {
            main.mapView.setRegion(coordinateRegion, animated: true)
            main.mapView.showsUserLocation = true
        }
    }
    
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
}
