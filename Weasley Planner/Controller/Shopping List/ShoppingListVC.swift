//
//  ShoppingListVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/9/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController {
    //---------------------
    // MARK: - UI Variables
    //---------------------
    var searchListHeight: NSLayoutConstraint!
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Shopping List"
        return bar
    }()
    
    let searchField: InputView = {
        let field = InputView()
        field.addDeepShadows()
        field.inputField.delegate = textManager
        field.inputType = .search
        return field
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.isHidden = true
        return view
    }()
    
    let searchList: UITableView = {
        let tableView = UITableView()
        tableView.register(ShoppingCell.self, forCellReuseIdentifier: "searchCell")
        return tableView
    }()
    
    let shoppingList: UITableView = {
        let tableView = UITableView()
        tableView.register(ShoppingCell.self, forCellReuseIdentifier: "shoppingCell")
        return tableView
    }()
    
    //-----------------------
    // MARK: - Data Variables
    //-----------------------
    var user: User?
    var previousEntries = [String]()
    var matchingEntries = [String]() {
        didSet {
            searchList.reloadData()
        }
    }
    
    var shoppingItems = [Item]() {
        didSet {
            shoppingList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        beginConnectionTest()
        loadPreviousEntries()
        observeFamilyShoppingList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textManager.delegate = self
        titleBar.delegate = self
    }
    
    func combineLikeItems(forItem item: Item) -> Item {
        let itemsToCombine = checkForLikeItems(forItem: item)
        var newQuantity = ""
        var newDouble = 0.0
        var newInt = 0
        var newFraction = Fraction()
        var obtained: Bool {
            for foundItem in itemsToCombine {
                if foundItem.obtained == false {
                    return false
                }
            }
            return true
        }
        
        for foundItem in itemsToCombine {
            if let itemInt = Int(foundItem.quantity), itemInt != 0 {
                newInt += itemInt
            } else if let itemDouble = Double(foundItem.quantity), itemDouble != 0.0 {
                newDouble += itemDouble
            } else {
                print("COMBINE: Couldn't cast \(foundItem.quantity) as a Double or Int...")
                if foundItem.quantity.contains("/") {
                    let fractionParts = foundItem.quantity.split(separator: "/")
                    if let numerator = Int(String(fractionParts[0])), let denominator = Int(String(fractionParts[1])) {
                        let foundFraction = Fraction(num: numerator, den: denominator)
                        if newFraction.description == "0/0" {
                            newFraction = foundFraction
                        } else {
                            newFraction = newFraction.add(foundFraction)
                        }
                    }
                }
            }
        }
        
        if newInt != 0 {
            newQuantity = "\(newInt)"
        } else if newDouble != 0.0 {
            newQuantity = "\(newDouble)"
        } else {
            newQuantity = newFraction.description
        }
        
        let combinedItem = Item(quantity: "\(newQuantity)", unitOfMeasurement: item.unitOfMeasurement, name: item.name, obtained: obtained)
        return combinedItem
    }
    
    func checkForLikeItems(forItem item: Item) -> [Item] {
        var itemsToCombine = [item]
        var index = 0
        
        for shoppingItem in shoppingItems {
            if shoppingItem.name == item.name {
                itemsToCombine.append(shoppingItem)
                shoppingItems.remove(at: index)
            }
            index += 1
        }
        
        return itemsToCombine
    }
    
    func loadPreviousEntries() {
        let defaults = UserDefaults.standard
        if let previousEntries = defaults.array(forKey: "previousEntries") as? [String] {
            self.previousEntries = previousEntries
        }
    }
    
    func saveNewPreviousEntry(withText text: String) {
        var shouldSave = true
        
        for entry in previousEntries {
            if text == entry {
                shouldSave = false
                break
            }
        }
        
        if shouldSave {
            let defaults = UserDefaults.standard
            
            previousEntries.append(text)
            defaults.set(previousEntries, forKey: "previousEntries")
        }
    }
    
    func searchShoppingListForDuplicate(_ item: Item) {
        var i = 0
        var itemToEdit: Item? {
            let itemName = item.name
            
            for _ in shoppingItems {
                let index = IndexPath(row: i, section: 0)
                let cell = shoppingList.cellForRow(at: index) as! ShoppingCell
                if let cellItemName = cell.item?.name {
                    if itemName == cellItemName {
                        return cell.item
                    } else {
                        i += 1
                    }
                }
            }
            return nil
        }
        
        if itemToEdit == nil {
            shoppingItems.append(item)
            updateShoppingList()
        } else {
            if item.quantity == "" {
                if shoppingItems[i].quantity == "" {
                    shoppingItems[i].quantity = "2"
                } else {
                    shoppingItems[i].quantity = "1"
                }
            } else {
                shoppingItems[i].quantity += item.quantity
            }
            updateShoppingList()
        }
    }
    
    func addNewItem() {
        if let text = searchField.inputField.text {
            let newItem = createItemFromText(text)
            searchShoppingListForDuplicate(newItem)
            searchField.inputField.text = ""
            
            saveNewPreviousEntry(withText: text)
        }
    }
    
    func createItemFromText(_ text: String) -> Item {
        let itemQuantity = text.quantity()
        let itemMeasurement = text.measurement()
        let itemName = text.trimming(quantity: itemQuantity, andMeasurement: itemMeasurement)
        
        let newItem = Item(quantity: itemQuantity, name: itemName, obtained: false)
        return newItem
    }
    
    @objc func clearListPressed(_ sender: TextButton?) {
        showAlert(.clearShoppingList)
    }
    
    func clearList() {
        shoppingItems = []
        updateShoppingList()
    }
}
