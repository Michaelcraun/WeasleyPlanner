//
//  AddEventLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/27/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import MapKit

extension AddEventVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(locationField)
        view.addSubview(titleField)
        view.addSubview(dateField)
        view.addSubview(userField)
        view.addSubview(locationList)
        view.addSubview(titleBar)
        view.addSubview(saveButton)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        locationField.anchor(top: titleBar.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                 size: .init(width: 0, height: 30))
        
        locationsListHeight = NSLayoutConstraint(item: locationList,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 0)
        
        locationList.backgroundColor = primaryColor
        locationList.dataSource = self
        locationList.delegate = self
        locationList.addConstraint(locationsListHeight)
        locationList.anchor(top: locationField.bottomAnchor,
                            leading: locationField.leadingAnchor,
                            trailing: locationField.trailingAnchor,
                            padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        titleField.anchor(top: locationField.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                          size: .init(width: 0, height: 30))
        
        datePicker.anchor()
        dateField.inputField.inputView = datePicker
        dateField.anchor(top: titleField.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                         size: .init(width: 0, height: 30))
        
        userPicker.anchor()
        userField.inputField.inputView = userPicker
        userField.anchor(top: dateField.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                         size: .init(width: 0, height: 30))
        
        if eventType == .meal {
            //TODO: Segue to Recipe List so user can pick a meal/add a new one
        }
        
        saveButton.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.bottomAnchor,
                          padding: .init(top: 0, left: 5, bottom: 5, right: 5),
                          size: .init(width: 0, height: 40))
    }
}

extension AddEventVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataHandler.instance.familyUsers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let user = DataHandler.instance.familyUsers[row]
        let userPane = UserPane()
        userPane.userIcon = user.icon
        userPane.userName = user.name
        userPane.userLocation = user.location
        userPane.userStatus = user.status
        userPane.layoutForUser(with: 60)
        return userPane
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

extension AddEventVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationCell
        let indexedLocation = matchingLocations[indexPath.row]
        cell.layoutCell(forLocation: indexedLocation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let location = matchingLocations[indexPath.row]
        if let locationName = location.name {
            selectedLocation = location
            locationField.inputField.text = locationName
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func animateLocationTable(shouldOpen: Bool) {
        locationList.removeConstraint(locationsListHeight)
        if shouldOpen {
            locationsListHeight = NSLayoutConstraint(item: locationList,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: 180)
        } else {
            locationsListHeight = NSLayoutConstraint(item: locationList,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: 0)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.locationList.addConstraint(self.locationsListHeight)
            self.locationList.updateConstraints()
        }, completion: { (finished) in
            if shouldOpen {
                self.locationList.reloadData()
            }
        })
    }
    
    func performSearch(searchText: String) {
        matchingLocations.removeAll()
        guard let userCoordinate = user?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(userCoordinate, 100000, 100000)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error != nil {
                //TODO: Show alert
            } else {
                for mapItem in response!.mapItems {
                    self.matchingLocations.append(mapItem)
                }
            }
        }
    }
}

extension AddEventVC: ModernSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
//            locationSearchBar.setDatas(datas: [])
        } else {
            performSearch(searchText: searchText)
        }
    }
}
