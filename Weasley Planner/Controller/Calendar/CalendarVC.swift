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
        
        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        displayLoadingView(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.observeFamilyEvents()
            self.displayLoadingView(false)
        }
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
        calendarView.scrollToDate(today) {
            self.calendarView.selectDates([today])
        }
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
