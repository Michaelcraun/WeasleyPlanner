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
    var shouldDismiss = false
    var eventList = [Event]()
    var eventsForDay = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        //------------------
        // MARK: - TEST DATA
        //------------------
        let doctor = Event(date: Date(), location: "2001 Stults Rd, Huntington, IN 46750", title: "Doctor Appointment", type: .appointment)
        let laundry = Event(date: Date(), title: "Laundry", type: .chore)
        let fishSticks = Event(date: Date(), title: "Fish Sticks", type: .meal)
        eventList = [doctor, laundry, fishSticks]

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
    }
    
    @objc func scrollToToday(_ sender: UIButton?) {
        let today = Date()
        calendarView.scrollToDate(today)
        calendarView.selectDates([today])
    }
}
