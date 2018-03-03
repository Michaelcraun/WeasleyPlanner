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
    //---------------------
    // MARK: - UI Variables
    //---------------------
    var locationsListHeight: NSLayoutConstraint!
    
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Add Event"
        return bar
    }()
    
    let locationField: InputView = {
        let field = InputView()
        field.inputField.delegate = textManager
        field.inputType = .location
        return field
    }()
    
    let locationList: UITableView = {
        let tableView = UITableView()
        tableView.addMidShadows()
        tableView.backgroundColor = primaryColor
        tableView.register(LocationCell.self, forCellReuseIdentifier: "locationCell")
        tableView.separatorStyle = .none
        return tableView
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
    var selectedLocation: MKMapItem?
    var matchingLocations = [MKMapItem]() {
        didSet {
            locationList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPicker.dataPicker.dataSource = self
        userPicker.dataPicker.delegate = self
        
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        if let selectedLocation = selectedLocation {
            if let eventLocation = selectedLocation.placemark.location { newEvent.location = eventLocation }
            if let locationAddress = selectedLocation.placemark.title { newEvent.locationString = locationAddress }
        }
        updateFamilyEvent(newEvent)
    }
}
