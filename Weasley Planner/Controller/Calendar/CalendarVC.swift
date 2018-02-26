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
    
    let calendarView: JTAppleCalendarView = {
        let view = JTAppleCalendarView()
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.minimumLineSpacing = 0
        view.minimumInteritemSpacing = 0
        view.register(CalendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        view.scrollDirection = .horizontal
        return view
    }()
    
    let eventTable = UITableView()
    
    //MARK: Data Variables
    var formatter = DateFormatter()
    var shouldDismiss = false
    var eventList = [Event]()
    var eventsForSelectedDay = [Event]()
    var appointments = [Event]()
    var chores = [Event]()
    var meals = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self

        layoutView()
        beginConnectionTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        
    }
}
