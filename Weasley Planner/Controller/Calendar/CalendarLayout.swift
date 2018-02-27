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
        let calendarControlBar: UIView = {
            let bar = UIView()
            bar.backgroundColor = primaryColor
            
            let todayButton: UIButton = {
                let button = UIButton()
                button.addTarget(self, action: #selector(scrollToToday(_:)), for: .touchUpInside)
                button.setTitle("TODAY", for: .normal)
                button.sizeToFit()
                button.titleLabel?.font = UIFont(name: secondaryFontName, size: 10)
                return button
            }()
            
            let dayStack: UIStackView = {
                let stackView = UIStackView()
                stackView.alignment = .fill
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                
                let daysArray = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                daysArray.forEach({ (title) in
                    let dayLabel = self.createDayLabel(withTitle: title)
                    stackView.addArrangedSubview(dayLabel)
                })
                return stackView
            }()
            
            bar.addSubview(yearLabel)
            bar.addSubview(monthLabel)
            bar.addSubview(todayButton)
            bar.addSubview(dayStack)
            
            yearLabel.anchor(top: bar.topAnchor,
                             leading: bar.leadingAnchor,
                             padding: .init(top: 10, left: 5, bottom: 0, right: 0))
            
            monthLabel.anchor(leading: yearLabel.trailingAnchor,
                              bottom: yearLabel.bottomAnchor,
                              padding: .init(top: 0, left: 5, bottom: 0, right: 0))
            
            todayButton.anchor(trailing: bar.trailingAnchor,
                               centerY: yearLabel.centerYAnchor,
                               padding: .init(top: 0, left: 0, bottom: 0, right: 10))
            
            dayStack.anchor(top: yearLabel.bottomAnchor,
                            leading: bar.leadingAnchor,
                            trailing: bar.trailingAnchor,
                            padding: .init(top: 2, left: 0, bottom: 0, right: 0))
            
            bar.anchor(size: .init(width: 0, height: 53))
            
            return bar
        }()
        
        view.backgroundColor = secondaryColor
        view.addSubview(calendarControlBar)
        view.addSubview(calendarView)
        view.addSubview(eventTable)
        view.addSubview(titleBar)
        
        titleBar.anchor(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        size: .init(width: 0, height: topBannerHeight))
        
        calendarControlBar.anchor(top: titleBar.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor)
        
        calendarView.anchor(top: calendarControlBar.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            size: .init(width: 0, height: 50))
        
        eventTable.backgroundColor = .clear
        eventTable.dataSource = self
        eventTable.delegate = self
        eventTable.addBorder()
        eventTable.register(EventTableCell.self, forCellReuseIdentifier: "eventCell")
        eventTable.separatorStyle = .none
        eventTable.anchor(top: calendarView.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        scrollToToday(nil)
        calendarView.visibleDates { (visibleDates) in
            self.updateCalendarLabels(withVisibleDates: visibleDates)
        }
    }
    
    func createDayLabel(withTitle title: String) -> UILabel {
        let dayLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: secondaryFontName, size: 10)
            label.text = title
            label.textAlignment = .center
            label.textColor = primaryTextColor
            return label
        }()
        return dayLabel
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
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2052 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 1,
                                                 generateInDates: .forFirstMonthOnly,
                                                 generateOutDates: .off,
                                                 hasStrictBoundaries: false)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        let eventsForDay = eventList.filterForDay(date)
        cell.layoutCell()
        cell.dayLabel.text = cellState.text
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        eventsForDay = eventList.filterForDay(cellState.date)
        eventTable.reloadData()
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        eventsForDay = eventList.filterForDay(cellState.date)
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateCalendarLabels(withVisibleDates: visibleDates)
    }
    
    func handleCellElements(view: JTAppleCell?, cellState: CellState, events: [Event]) {
        guard let cell = view as? CalendarCell else { return }
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            cell.dayLabel.textColor = primaryTextColor
        } else {
            cell.selectedView.isHidden = true
            cell.dayLabel.textColor = secondaryTextColor
        }
        
        if events.count > 0 {
            cell.eventView.isHidden = false
        } else {
            cell.eventView.isHidden = true
        }
    }
    
    func updateCalendarLabels(withVisibleDates visibleDates: DateSegmentInfo) {
        var firstDate: Date {
            if let firstIndate = visibleDates.indates.first?.date {
                return firstIndate
            } else if let firstMonthDate = visibleDates.monthDates.first?.date {
                return firstMonthDate
            } else if let firstOutdate = visibleDates.outdates.first?.date {
                return firstOutdate
            }
            return Date()
        }
        
        yearLabel.text = {
            formatter.dateFormat = "yyyy"
            return formatter.string(from: firstDate)
        }()

        monthLabel.text = {
            formatter.dateFormat = "MMMM"
            return formatter.string(from: firstDate)
        }()
    }
}

//----------------------------------------
// MARK: TABLEVIEW DATASOURCE AND DELEGATE
//----------------------------------------

extension CalendarVC: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventsForDay.count > 0 { return eventsForDay.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell
        if eventsForDay.count > 0 {
            cell.layoutCell(forEvent: eventsForDay[indexPath.row])
        } else {
            cell.layoutCellForNoEvents()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            let headerLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = "EVENTS"
                label.textAlignment = .center
                label.textColor = primaryTextColor
                return label
            }()
            
            view.addSubview(headerLabel)
            headerLabel.anchor(top: view.topAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               bottom: view.bottomAnchor,
                               padding: .init(top: 2, left: 2, bottom: 2, right: 2))
            
            return view
        }()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
