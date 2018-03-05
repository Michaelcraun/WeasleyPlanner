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
        view.addSubview(recipeList)
        view.addSubview(titleBar)
        view.addSubview(saveButton)
        
        if eventType == .meal {
            
        } else if eventType == .chore {
            view.addSubview(recurrenceView)
            
            recurrenceView.anchor(top: userField.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        }
        
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
        
        recipeListHeight = NSLayoutConstraint(item: recipeList,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 0)
        
        recipeList.backgroundColor = primaryColor
        recipeList.dataSource = self
        recipeList.delegate = self
        recipeList.addConstraint(recipeListHeight)
        recipeList.anchor(top: titleField.bottomAnchor,
                          leading: titleField.leadingAnchor,
                          trailing: titleField.trailingAnchor,
                          padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
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
        
        saveButton.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.bottomAnchor,
                          padding: .init(top: 0, left: 5, bottom: 5, right: 5),
                          size: .init(width: 0, height: 40))
    }
}

//-------------------------------------------
// MARK: - PICKERVIEW DATASOURCE AND DELEGATE
//-------------------------------------------
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

//------------------------------------------
// MARK: - TABLEVIEW DATASOURCE AND DELEGATE
//------------------------------------------
extension AddEventVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == locationList {
            return matchingLocations.count + 1
        } else {
            return matchingRecipes.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == locationList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationCell
            if indexPath.row == 0 {
                cell.layoutCancelCell()
            } else {
                if matchingLocations.count == 0 {
                    cell.layoutCellForNo("Location")
                } else {
                    let indexedLocation = matchingLocations[indexPath.row - 1]
                    cell.layoutCell(forLocation: indexedLocation)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
            if indexPath.row == 0 {
                cell.layoutCancelCell()
            } else {
                if matchingRecipes.count == 0 {
                    cell.layoutCellForNo("Recipe")
                } else {
                    let indexedRecipe = matchingRecipes[indexPath.row]
                    cell.layoutCellForRecipe(indexedRecipe)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            if tableView == locationList {
                return 50
            } else {
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        if tableView == locationList {
            let location = matchingLocations[indexPath.row]
            if let locationName = location.name {
                selectedLocation = location
                locationField.inputField.text = locationName
            }
        } else {
            let meal = matchingRecipes[indexPath.row]
            titleField.inputField.text = meal.title
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func animateTableView(_ tableView: UITableView, shouldOpen: Bool) {
        var heightConstant: CGFloat {
            switch shouldOpen {
            case true: return 180
            case false: return 0
            }
        }
        
        var heightConstraint: NSLayoutConstraint {
            switch tableView {
            case locationList:
                tableView.removeConstraint(locationsListHeight)
                locationsListHeight = NSLayoutConstraint(item: tableView,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1.0,
                                                         constant: heightConstant)
                return locationsListHeight
            default:
                tableView.removeConstraint(recipeListHeight)
                recipeListHeight = NSLayoutConstraint(item: tableView,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1.0,
                                                      constant: heightConstant)
                return recipeListHeight
            }
        }
            
        UIView.animate(withDuration: 0.2, animations: {
            tableView.frame.size.height = heightConstant
        }, completion: { (finished) in
            tableView.addConstraint(heightConstraint)
            tableView.updateConstraints()
            
            if shouldOpen {
                tableView.reloadData()
            }
        })
    }
    
    func performLocationSearch(searchText: String) {
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
    
    func performRecipeSearch(searchText: String) {
        matchingRecipes.removeAll()
        matchingRecipes = DataHandler.instance.familyRecipes.filterByTitle(searchText: searchText)
    }
}
