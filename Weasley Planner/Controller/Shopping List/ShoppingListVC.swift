//
//  ShoppingListVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController {
    private let identifier = "showShoppingList"
    
    //MARK: UI Variables
    let titleBar = TitleBar()
    let shoppingList = UITableView()
    let addEntryView = UIView()
    let addEntryField = UISearchBar()
    let previousEntriesTable = UITableView()
    
    //MARK: Data Variables
    var user: User?
    var previousEntries = [String]()
    var shoppingItems = [Item]() {
        didSet {
            shoppingList.reloadData()
        }
    }
    
    var filteredEntries = [String]() {
        didSet {
            previousEntriesTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        observeFamilyShoppingList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func loadPreviousEntries() {
        let defaults = UserDefaults.standard
        if let previousEntries = defaults.array(forKey: "previousEntries") as? [String] {
            self.previousEntries = previousEntries
        }
    }
    
    func saveNewPreviousEntry(withText text: String) {
        previousEntries.append(text)
    }
    
    func searchPreviousEntries(withSearchText text: String) {
        filteredEntries = []
        
        let plainText = text.lowercased()
        for entry in previousEntries {
            let plainEntry = entry.lowercased()
            if plainEntry == plainText {
                filteredEntries.append(entry)
            }
        }
    }
}
