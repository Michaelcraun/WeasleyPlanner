//
//  PickerView.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/19/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class DurationPicker: UIView {
    let cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissPicker(_:)), for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissPicker(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    let dataPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = secondaryColor
        return picker
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .black
        
        let controlBar: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            view.addSubview(cancelButton)
            view.addSubview(doneButton)
            
            cancelButton.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                size: .init(width: 50, height: 0))
            
            doneButton.anchor(top: view.topAnchor,
                              trailing: view.trailingAnchor,
                              bottom: view.bottomAnchor,
                              padding: .init(top: 5, left: 0, bottom: 5, right: 5),
                              size: .init(width: 50, height: 0))
            
            return view
        }()
        
        self.addSubview(controlBar)
        self.addSubview(dataPicker)
        
        controlBar.anchor(top: self.topAnchor,
                          leading: self.leadingAnchor,
                          trailing: self.trailingAnchor,
                          padding: .init(top: 1, left: 0, bottom: 0, right: 0),
                          size: .init(width: 0, height: 40))
        
        dataPicker.anchor(top: controlBar.bottomAnchor,
                          leading: self.leadingAnchor,
                          trailing: self.trailingAnchor,
                          bottom: self.bottomAnchor,
                          padding: .init(top: 1, left: 0, bottom: 0, right: 0))
    }
    
    @objc private func dismissPicker(_ sender: UIButton) {
        endEditing(true)
    }
}
