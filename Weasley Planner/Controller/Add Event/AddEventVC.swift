//
//  AddEventVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/27/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddEventVC: UIViewController {
    //--------------------
    //MARK: - UI Variables
    //--------------------
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Add Event"
        return bar
    }()
    
    let titleField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .title
        return field
    }()
    
    let dateField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .date
        return field
    }()
    
    let userField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .user
        return field
    }()
    
    let locationSearchBar: ModernSearchBar = {
        let bar = ModernSearchBar()
        bar.placeholder = "Location..."
        bar.searchLabel_font = UIFont(name: fontName, size: smallFontSize)
        bar.searchLabel_textColor = primaryTextColor
        bar.searchLabel_backgroundColor = primaryColor
        bar.suggestionsView_maxHeight = 180
        bar.suggestionsView_separatorStyle = .none
        bar.suggestionsView_contentViewColor = primaryColor
        return bar
    }()
    
    let mealSearchBar: ModernSearchBar = {
        let bar = ModernSearchBar()
        bar.placeholder = "Meal..."
        bar.searchLabel_font = UIFont(name: fontName, size: smallFontSize)
        bar.searchLabel_textColor = primaryTextColor
        bar.searchLabel_backgroundColor = primaryColor
        bar.suggestionsView_maxHeight = 180
        bar.suggestionsView_separatorStyle = .none
        bar.suggestionsView_contentViewColor = primaryColor
        return bar
    }()
    
    let saveButton: TextButton = {
        let button = TextButton()
        button.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        button.title = "Save Event"
        return button
    }()
    
    //--------------------
    // MARK: - INPUT VIEWS
    //--------------------
    let userPicker: DataPicker = {
        let picker = DataPicker()
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    let datePicker: DataPicker = {
        let picker = DataPicker()
        picker.isDatePicker = true
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    //MARK: Data Variables
    var user: User?
    var eventToEdit: Event?
    var assignedUser: User?
    var eventType: EventType = .appointment
    var selectedDate: Date?
    var selectedLocation: CLLocation?
    var matchingLocations = [MKMapItem]() {
        didSet {
            var matchingItems = [String]()
            for location in matchingLocations {
                guard let locationName = location.name else { return }
                let suggestionsView = locationSearchBar.getSuggestionsView()
                
                matchingItems.append(locationName)
                locationSearchBar.setDatas(datas: matchingItems)
                suggestionsView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPicker.dataPicker.dataSource = self
        userPicker.dataPicker.delegate = self
        
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationSearchBar.delegateModernSearchBar = self
        mealSearchBar.delegateModernSearchBar = self
        textManager.delegate = self
        titleBar.delegate = self
        
    }
    
    @objc func pickerButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        
        if sender.title(for: .normal) == "Done" {
            if sender == userPicker.doneButton {
                let row = userPicker.dataPicker.selectedRow(inComponent: 0)
                
                assignedUser = DataHandler.instance.familyUsers[row]
                userField.inputField.text = assignedUser?.name!
            } else if sender == datePicker.doneButton {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM dd, yyyy h:mm a"
                
                selectedDate = datePicker.datePicker.date
                dateField.inputField.text = formatter.string(from: selectedDate!)
            }
        }
    }
    
    @objc func saveButtonPressed(_ sender: TextButton?) {
        guard let title = titleField.inputField.text, title != "", let date = selectedDate else {
            showAlert(.newEventError)
            return
        }
        
        let eventIdentifier = DataHandler.instance.createUniqueIDString(with: title)
        let newEvent = Event(date: date, title: title, type: eventType, identifier: eventIdentifier)
        if let eventUser = assignedUser { newEvent.assignedUser = eventUser }
        if let eventLocation = selectedLocation {
            let geoCoder = CLGeocoder()
            var addressString = ""
            
            newEvent.location = eventLocation
            geoCoder.reverseGeocodeLocation(eventLocation, completionHandler: { (placemarks, error) in
                if let _ = error { return }
                guard let placemarks = placemarks else { return }
                let placemark = placemarks[0]
                
                if let subThoroughfare = placemark.subThoroughfare {
                    addressString = subThoroughfare
                }
                
                if let thoroughfare = placemark.thoroughfare {
                    if addressString == "" {
                        addressString = thoroughfare
                    } else {
                        addressString += " \(thoroughfare)"
                    }
                }
                
                if let locality = placemark.locality {
                    if addressString == "" {
                        addressString = locality
                    } else {
                        addressString += ", \(locality)"
                    }
                }
                
                if let country = placemark.country {
                    if addressString == "" {
                        addressString = country
                    } else {
                        addressString += ", \(country)"
                    }
                }
                
                if let postalCode = placemark.postalCode {
                    if addressString == "" {
                        addressString = postalCode
                    } else {
                        addressString += ", \(postalCode)"
                    }
                }
                
                newEvent.locationString = addressString
            })
        }
        updateFamilyEvent(newEvent)
    }
}
