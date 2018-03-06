//
//  RecurrenceView.swift
//  Weasley Planner
//
//  Created by Michael Craun on 3/3/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class RecurrenceView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    enum Recurrence: String {
        case daily = "day"
        case weekly = "week"
        case monthly = "month"
        case yearly = "year"
        static let allRecurrences: [Recurrence] = [.daily, .weekly, .monthly, .yearly]
        
        var pluralValue: String {
            switch self {
            case .daily: return "days"
            case .weekly: return "weeks"
            case .monthly: return "months"
            case .yearly: return "years"
            }
        }
        
        func getRecurrenceString(numOfTimes: Int) -> String {
            var recurrenceString = ""
            if numOfTimes > 1 {
                recurrenceString = "\(numOfTimes)|\(self.pluralValue)"
            } else {
                recurrenceString = "\(numOfTimes)|\(self.rawValue)"
            }
            return recurrenceString
        }
    }
    
    var recurrenceType: Recurrence = .daily
    var recurrenceString = ""
    var isRecurringChore: Bool = false {
        didSet {
            switch isRecurringChore {
            case true: recurrenceLabel.text = "Repeat this event every:"
            case false:
                recurrenceLabel.text = "Do not repeat this event."
                recurrenceString = ""
            }
            updateRecurrenceView(isRecurringChore)
        }
    }
    
    let indicatorButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(recurrenceButtonPressed(_:)), for: .touchUpInside)
        button.layer.borderColor = primaryColor.cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 10
        return button
    }()
    
    let recurrenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: secondaryFontName, size: smallFontSize)
        label.text = "Do not repeat this event."
        label.textColor = secondaryTextColor
        return label
    }()
    
    let amountField: UITextField = {
        let field = UITextField()
        field.addBorder()
        field.alpha = 0
        field.delegate = textManager
        field.keyboardType = .numberPad
        field.font = UIFont(name: secondaryFontName, size: smallFontSize)
        field.textAlignment = .center
        return field
    }()
    
    let recurrenceField: UITextField = {
        let field = UITextField()
        field.addBorder()
        field.delegate = textManager
        field.alpha = 0
        field.font = UIFont(name: secondaryFontName, size: smallFontSize)
        field.isEnabled = false
        field.textAlignment = .center
        return field
    }()
    
    let recurrenceTypePicker: DataPicker = {
        let picker = DataPicker()
        picker.cancelButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        picker.doneButton.addTarget(self, action: #selector(pickerButtonPressed(_:)), for: .touchUpInside)
        return picker
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recurrenceTypePicker.dataPicker.dataSource = self
        recurrenceTypePicker.dataPicker.delegate = self
        
        self.addSubview(indicatorButton)
        self.addSubview(recurrenceLabel)
        self.addSubview(amountField)
        self.addSubview(recurrenceField)
        
        indicatorButton.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               padding: .init(top: 5, left: 5, bottom: 0, right: 0),
                               size: .init(width: 20, height: 20))
        
        recurrenceLabel.anchor(leading: indicatorButton.trailingAnchor,
                               trailing: self.trailingAnchor,
                               centerY: indicatorButton.centerYAnchor,
                               padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        amountField.anchor(top: indicatorButton.bottomAnchor,
                           leading: self.leadingAnchor,
                           bottom: self.bottomAnchor,
                           padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                           size: .init(width: 50, height: 30))
        
        recurrenceTypePicker.anchor()
        recurrenceField.inputView = recurrenceTypePicker
        recurrenceField.anchor(top: indicatorButton.bottomAnchor,
                               leading: amountField.trailingAnchor,
                               trailing: self.trailingAnchor,
                               bottom: self.bottomAnchor,
                               padding: .init(top: 5, left: 5, bottom: 5, right: 5),
                               size: .init(width: 0, height: 30))
    }
    
    func updateRecurrenceView(_ shouldShowDetails: Bool) {
        if let recurrenceInterval = Int(amountField.text!), recurrenceInterval != 0, let recurrenceType = recurrenceField.text, recurrenceType != "" {
            recurrenceString = "\(recurrenceInterval)|\(recurrenceType)"
        }
        
        if recurrenceString != "" {
            let recurrenceParts = recurrenceString.split(separator: "|")
            let recurrenceAmount = String(recurrenceParts[0])
            let recurrenceType = String(recurrenceParts[1])
            
            amountField.text = recurrenceAmount
            recurrenceField.text = recurrenceType
            
            if let selectedRecurrence = Recurrence(rawValue: recurrenceType) {
                self.recurrenceType = selectedRecurrence
            } else {
                self.recurrenceType = {
                    switch recurrenceType {
                    case "days": return .daily
                    case "weeks": return .weekly
                    case "months": return .monthly
                    default: return .yearly
                    }
                }()
            }
        }
        
        if shouldShowDetails {
            amountField.fadeAlphaTo(1)
            recurrenceField.fadeAlphaTo(1)
        } else {
            amountField.fadeAlphaTo(0)
            recurrenceField.fadeAlphaTo(0)
            recurrenceString = ""
        }
    }
    
    @objc func recurrenceButtonPressed(_ sender: UIButton?) {
        isRecurringChore = !isRecurringChore
        switch isRecurringChore {
        case true: indicatorButton.backgroundColor = primaryColor
        case false: indicatorButton.backgroundColor = .clear
        }
    }
    
    @objc func pickerButtonPressed(_ sender: UIButton) {
        endEditing(true)
        
        if sender == recurrenceTypePicker.doneButton {
            let row = recurrenceTypePicker.dataPicker.selectedRow(inComponent: 0)
            let selectedRecurrenceType = Recurrence.allRecurrences[row]
            recurrenceType = selectedRecurrenceType
            
            if let numOfTimes = Int(amountField.text!) {
                recurrenceString = recurrenceType.getRecurrenceString(numOfTimes: numOfTimes)
                updateRecurrenceView(true)
            } else {
                print("RECURRENCE: Error getting string!")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return Recurrence.allRecurrences.count }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowLabel: UILabel = {
            let label = UILabel()
            label.addBorder()
            label.addLightShadows()
            label.backgroundColor = secondaryColor
            label.font = UIFont(name: secondaryFontName, size: smallFontSize)
            label.layer.cornerRadius = 5
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            label.text = {
                if let numOfRecurrences = Int(amountField.text!) {
                    if numOfRecurrences > 1 {
                        return Recurrence.allRecurrences[row].pluralValue
                    }
                }
                return Recurrence.allRecurrences[row].rawValue
            }()
            return label
        }()
        return rowLabel
    }
}
