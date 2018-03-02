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
        view.addSubview(locationSearchBar)
        view.addSubview(titleField)
        view.addSubview(dateField)
        view.addSubview(userField)
        view.addSubview(titleBar)
        view.addSubview(saveButton)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        locationSearchBar.anchor(top: titleBar.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 0, left: 5, bottom: 0, right: 5),
                                 size: .init(width: 0, height: 30))
        
        titleField.anchor(top: locationSearchBar.bottomAnchor,
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
            view.addSubview(mealSearchBar)
            
            let recipeTitles = DataHandler.instance.familyRecipes.getTitles()
            mealSearchBar.setDatas(datas: recipeTitles)
            mealSearchBar.anchor(top: userField.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 5, left: 5, bottom: 0, right: 5),
                                 size: .init(width: 0, height: 30))
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

extension AddEventVC: ModernSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            locationSearchBar.setDatas(datas: [])
        } else {
            performSearch(searchText: searchText)
        }
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
