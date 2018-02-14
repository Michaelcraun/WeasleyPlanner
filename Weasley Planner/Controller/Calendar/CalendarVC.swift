//
//  CalendarVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {
    private let identifier = "showCalendar"
    
    //MARK: UI Variables
    let titleBar = TitleBar()
//    let dateCollection = UICollectionView()
    let eventTable = UITableView()
    
    //MARK: Data Variables
    var shouldDismiss = false
    var eventList = [Event]()
    var eventsForSelectedDay = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        
    }
}
