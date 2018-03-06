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
        if #available(iOS 10.0, *) {
            eventTable.refreshControl = refreshControl
        } else {
            eventTable.addSubview(refreshControl)
        }
        eventTable.anchor(top: calendarView.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        calendarView.visibleDates { (visibleDates) in
            self.updateCalendarLabels(withVisibleDates: visibleDates)
            self.scrollToToday(nil)
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
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        let eventsForDay = DataHandler.instance.familyEvents.filterForDay(date)
        cell.layoutCell()
        cell.dayLabel.text = cellState.text
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: calendarBounds[0])!
        let endDate = formatter.date(from: calendarBounds[1])!
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
        let eventsForDay = DataHandler.instance.familyEvents.filterForDay(date)
        cell.layoutCell()
        cell.dayLabel.text = cellState.text
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        calendarView.deselectAllDates()
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        eventsForDay = DataHandler.instance.familyEvents.filterForDay(cellState.date)
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
        eventTable.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        eventsForDay = DataHandler.instance.familyEvents.filterForDay(cellState.date)
        handleCellElements(view: cell, cellState: cellState, events: eventsForDay)
        eventTable.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        calendarView.deselectAllDates()
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
// MARK: - TABLEVIEW DATASOURCE AND DELEGATE
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
            cell.layoutCellForNo("Event")
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
            headerLabel.fillTo(view, withPadding: .init(top: 2, left: 2, bottom: 2, right: 2))
            return view
        }()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, handler) in
            let cell = tableView.cellForRow(at: indexPath) as! EventTableCell
            guard let eventToDelete = cell.event else { return }
            
            self.removeFamilyEvent(eventToDelete)
        }
        delete.image = #imageLiteral(resourceName: "deleteIcon")
        
        let configuration = UISwipeActionsConfiguration.init(actions: [delete])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = eventsForDay[indexPath.row]
        showEventOptionsSheet(forEvent: selectedEvent)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showEventOptionsSheet(forEvent event: Event) {
        let optionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit Event", style: .default) { (action) in
            self.performSegue(withIdentifier: "showAddEvent", sender: event)
        }
        
        let addIngredientsAction = UIAlertAction(title: "Add Ingredients to Shopping LIst", style: .default) { (action) in
            // TODO: Add ingredients to shopping list (needs to be a meal that has ingredients)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            optionSheet.dismiss(animated: true, completion: nil)
        }
        
        if event.type == .meal {
            for recipe in DataHandler.instance.familyRecipes {
                if recipe.title == event.title && recipe.ingredients.count > 0 {
                    optionSheet.addAction(addIngredientsAction)
                }
            }
        }
        
        optionSheet.addAction(editAction)
        optionSheet.addAction(cancelAction)
        
        present(optionSheet, animated: true, completion: nil)
    }
}
