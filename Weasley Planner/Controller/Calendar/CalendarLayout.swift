//
//  CalendarLayout.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CalendarVC {
    func layoutView() {
        view.backgroundColor = secondaryColor
        view.addSubview(calendarView)
        view.addSubview(eventTable)
        view.addSubview(titleBar)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        calendarView.anchor(top: titleBar.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            size: .init(width: 0, height: 80))
        
        eventTable.backgroundColor = .clear
        eventTable.dataSource = self
        eventTable.delegate = self
        eventTable.register(EventTableCell.self, forCellReuseIdentifier: "eventCell")
        eventTable.separatorStyle = .none
        eventTable.anchor(top: calendarView.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}

//---------------------------------------------
// MARK: - CALENDARVIEW DATASOURCE AND DELEGATE
//---------------------------------------------

extension CalendarVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2052 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        //TODO: Configure cell
        return cell
    }
    
    
}

//----------------------------------------
// MARK: TABLEVIEW DATASOURCE AND DELEGATE
//----------------------------------------

extension CalendarVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell
        //TODO: Layout cell
        return cell
    }
    
    
}
