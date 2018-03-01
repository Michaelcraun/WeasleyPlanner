//
//  CalendarVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarVC: UIViewController {
    //MARK: UI Variables
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Calendar"
        return bar
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: largeFontSize)
        label.text = "YYYY"
        label.textColor = primaryTextColor
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: smallFontSize)
        label.text = "MMMM"
        label.textColor = primaryTextColor
        return label
    }()
    
    let calendarView: JTAppleCalendarView = {
        let view = JTAppleCalendarView()
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.addBorder()
        view.minimumLineSpacing = 0
        view.minimumInteritemSpacing = 0
        view.register(CalendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        view.scrollDirection = .horizontal
        view.scrollingMode = ScrollingMode.stopAtEachSection
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let eventTable = UITableView()
    
    //MARK: Data Variables
    var user: User?
    var formatter = DateFormatter()
    var eventList = [Event]()
    var eventsForDay = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        //------------------
        // MARK: - TEST DATA
        //------------------
        let doctor = Event(date: Date(),
                           locationString: "2001 Stults Rd, Huntington, IN 46750",
                           title: "Doctor Appointment",
                           type: .appointment,
                           identifier: DataHandler.instance.createUniqueIDString(with: "Doctor Appointment"))
        let laundry = Event(date: Date(),
                            title: "Laundry",
                            type: .chore,
                            identifier: DataHandler.instance.createUniqueIDString(with: "Laundry"))
        let fishSticks = Event(date: Date(),
                               title: "Fish Sticks",
                               type: .meal,
                               identifier: DataHandler.instance.createUniqueIDString(with: "Fish Sticks"))
        eventList = [doctor, laundry, fishSticks]

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        observeFamilyEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddEvent" {
            if let destination = segue.destination as? AddEventVC {
                destination.transitioningDelegate = transitioningDelegate
                destination.modalPresentationStyle = .custom
                
                destination.user = user
                if let sender = sender as? Event { destination.eventToEdit = sender }
                if let sender = sender as? EventType { destination.eventType = sender }
            }
        }
    }
    
    @objc func scrollToToday(_ sender: UIButton?) {
        let today = Date()
        calendarView.scrollToDate(today)
        calendarView.selectDates([today])
    }
    
    func showAddEventActionSheet() {
        let optionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let newAppointmentAction = UIAlertAction(title: "Add New Appointment", style: .default) { (action) in
            let eventType: EventType = .appointment
            self.performSegue(withIdentifier: "showAddEvent", sender: eventType)
        }
        
        let newChoreAction = UIAlertAction(title: "Add New Chore", style: .default) { (action) in
            let eventType: EventType = .chore
            self.performSegue(withIdentifier: "showAddEvent", sender: eventType)
        }
        
        let newMealAction = UIAlertAction(title: "Add New Meal", style: .default) { (action) in
            let eventType: EventType = .meal
            self.performSegue(withIdentifier: "showAddEvent", sender: eventType)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            optionSheet.dismiss(animated: true, completion: nil)
        }
        
        optionSheet.addAction(newAppointmentAction)
        optionSheet.addAction(newChoreAction)
        optionSheet.addAction(newMealAction)
        optionSheet.addAction(cancelAction)
        
        present(optionSheet, animated: true, completion: nil)
    }
}
