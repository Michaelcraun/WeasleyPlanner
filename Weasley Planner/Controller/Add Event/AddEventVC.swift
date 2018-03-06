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
    var recipeListHeight: NSLayoutConstraint!
    
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
    
    let recipeList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = primaryColor
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "recipeCell")
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
    
    let recurrenceView: RecurrenceView = {
        let view = RecurrenceView()
        return view
    }()
    
    //--------------------
    // MARK: - INPUT VIEWS
    //--------------------
    let datePicker: DataPicker = {
        let picker = DataPicker()
        picker.isDatePicker = true
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    let userPicker: DataPicker = {
        let picker = DataPicker()
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    //MARK: Data Variables
    let formatter = DateFormatter()
    var user: User?
    var assignedUser: User?
    var eventType: EventType = .appointment
    var selectedDate: Date?
    var selectedLocation: MKMapItem?
    var eventToEdit: Event? {
        didSet {
            if let eventType = eventToEdit?.type {
                self.eventType = eventType
            }
        }
    }
    
    var matchingLocations = [MKMapItem]() {
        didSet {
            locationList.reloadData()
        }
    }
    
    var matchingRecipes = [Recipe]() {
        didSet {
            recipeList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPicker.dataPicker.dataSource = self
        userPicker.dataPicker.delegate = self
        
        layoutView()
        loadEvent()
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
        
        guard let eventToEdit = eventToEdit else {
            let eventIdentifier = DataHandler.instance.createUniqueIDString(with: title)
            saveEvent(eventIdentifier, withTitle: title, andDate: date)
            return
        }
        
        let eventIdentifier = eventToEdit.identifier
        saveEvent(eventIdentifier, withTitle: title, andDate: date)
    }
    
    func saveEvent(_ identifier: String, withTitle title: String, andDate date: Date) {
        let newEvent = Event(date: date, title: title, type: eventType, identifier: identifier)
        if let eventUser = assignedUser { newEvent.assignedUser = eventUser }
        if let selectedLocation = selectedLocation {
            if let eventLocation = selectedLocation.placemark.location { newEvent.location = eventLocation }
            if let locationAddress = selectedLocation.placemark.title { newEvent.locationString = locationAddress }
        }
        
        if recurrenceView.isRecurringChore {
            let recurrenceString = recurrenceView.recurrenceString
            newEvent.recurrenceString = recurrenceString
        }
        
        updateFamilyEvent(newEvent)
    }
    
    func scheduleFutureEvents(withRecurrence recurrence: String, andEvent event: Event) {
        let dateComponents: DateComponents = {
            let recurrenceParts = recurrence.split(separator: "|")
            let recurrenceInterval = Int(String(recurrenceParts[0]))
            let recurrenceType = String(recurrenceParts[1])
            
            var _dateComponents = DateComponents()
            switch recurrenceType {
            case "day", "days": _dateComponents.day = recurrenceInterval
            case "week", "weeks": _dateComponents.day = recurrenceInterval! * 7
            case "month", "months": _dateComponents.month = recurrenceInterval
            default: _dateComponents.year = recurrenceInterval
            }
            return _dateComponents
        }()
        
        formatter.dateFormat = "MM dd yyyy"
        let calendar = Calendar.current
        guard let calendarBounds = formatter.date(from: calendarBounds[1]) else { return }
        guard let newEventDate = calendar.date(byAdding: dateComponents, to: event.date) else { return }
        
        if newEventDate <= calendarBounds {
            let newIdentifier = DataHandler.instance.createUniqueIDString(with: event.title)
            event.date = newEventDate
            event.identifier = newIdentifier
            updateFamilyEvent(event)
        }
    }
    
    func loadEvent() {
        guard let eventToEdit = eventToEdit else { return }
        formatter.dateFormat = "MMMM dd, yyyy h:mm a"
        selectedDate = eventToEdit.date
        selectedLocation = {
            guard let eventCoordinate = eventToEdit.location?.coordinate else { return nil }
            let eventPlacemark = MKPlacemark(coordinate: eventCoordinate)
            let eventMapItem = MKMapItem(placemark: eventPlacemark)
            return eventMapItem
        }()
        
        titleField.inputField.text = eventToEdit.title
        dateField.inputField.text = formatter.string(from: eventToEdit.date)
        if let userName = eventToEdit.assignedUser?.name { userField.inputField.text = userName }
        if let locationString = eventToEdit.locationString { locationField.inputField.text = locationString }
        if let recurrenceString = eventToEdit.recurrenceString, recurrenceString != "none" {
            recurrenceView.recurrenceString = recurrenceString
            recurrenceView.recurrenceButtonPressed(nil)
        }
    }
}
