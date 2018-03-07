//
//  RecipeCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/18/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    var recipe: Recipe?
    let allMeasurements: [UnitOfMeasurement] = [.cup, .dash, .pinch, .pound, .tablespoon, .teaspoon, .whole]
    var selectedMeasurement: UnitOfMeasurement = .cup {
        didSet {
            print("INGREDIENTS: selectedMeasurement: \(selectedMeasurement.rawValue)")
            self.measurementField.text = selectedMeasurement.shortHandNotation
        }
    }
    
    let measurementPicker: DataPicker = {
        let picker = DataPicker()
        return picker
    }()
    
    let quantityField: UITextField = {
        let field = UITextField()
        field.anchor(size: .init(width: 50, height: 0))
        field.delegate = textManager
        field.font = UIFont(name: secondaryFontName, size: smallerFontSize)
        field.addBorder()
        field.textAlignment = .center
        field.textColor = secondaryTextColor
        return field
    }()
    
    let measurementField: UITextField = {
        let field = UITextField()
        field.anchor(size: .init(width: 50, height: 0))
        field.delegate = textManager
        field.font = UIFont(name: secondaryFontName, size: smallerFontSize)
        field.addBorder()
        field.textAlignment = .center
        field.textColor = secondaryTextColor
        return field
    }()
    
    let itemField: UITextField = {
        let field = UITextField()
        field.addBorder()
        field.anchor()
        field.delegate = textManager
        field.font = UIFont(name: secondaryFontName, size: smallerFontSize)
        field.textAlignment = .center
        field.textColor = secondaryTextColor
        return field
    }()
    
    let instructionView: UITextView = {
        let textView = UITextView()
        textView.addBorder()
        textView.backgroundColor = secondaryColor
        textView.delegate = textManager
        textView.font = UIFont(name: secondaryFontName, size: smallerFontSize)
        textView.sizeToFit()
        textView.textColor = secondaryTextColor
        return textView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    //---------------------------
    // MARK: - LAYOUT FOR RECIPES
    //---------------------------
    func layoutCellForRecipe(_ recipe: Recipe) {
        clearCell()
        
        self.recipe = recipe
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = secondaryColor
            view.addBorder(clipsToBounds: false)
            view.addLightShadows()
            view.layer.cornerRadius = 5
            
            let recipeImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = recipe.image
                imageView.addBorder()
                imageView.layer.cornerRadius = 5
                return imageView
            }()
            
            let sourceLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallerFontSize)
                label.text = recipe.source
                label.textColor = primaryColor
                return label
            }()
            
            let recipeTitle: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallFontSize)
                label.numberOfLines = 3
                label.text = recipe.title
                label.textColor = secondaryTextColor
                return label
            }()
            
            view.addSubview(recipeImageView)
            view.addSubview(sourceLabel)
            view.addSubview(recipeTitle)
            
            recipeImageView.anchor(top: view.topAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   padding: .init(top: 5, left: 5, bottom: 5, right: 0),
                                   size: .init(width: 90, height: 0))
            
            sourceLabel.anchor(top: view.topAnchor,
                               leading: recipeImageView.trailingAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            recipeTitle.anchor(top: sourceLabel.bottomAnchor,
                               leading: recipeImageView.trailingAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 0, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        
        self.addSubview(cellView)
        cellView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    //-------------------------------
    // MARK: - LAYOUT FOR INGREDIENTS
    //-------------------------------
    func layoutIngredientCellHeader() -> UIView {
        clearCell()
        
        let ingredientHeaderView: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            let ingredientsLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.sizeToFit()
                label.text = "Ingredients"
                label.textAlignment = .center
                label.textColor = primaryTextColor
                return label
            }()
            
            let promptStack: UIStackView = {
                let stackView = UIStackView()
                stackView.alignment = .fill
                stackView.axis = .horizontal
                stackView.distribution = .fillProportionally
                stackView.spacing = 5
                
                let quantityLabel: UILabel = {
                    let label = UILabel()
                    label.anchor(size: .init(width: 50, height: 0))
                    label.font = UIFont(name: secondaryFontName, size: 10)
                    label.text = "QTY."
                    label.textAlignment = .center
                    label.textColor = primaryTextColor
                    return label
                }()
                
                let measurementLabel: UILabel = {
                    let label = UILabel()
                    label.anchor(size: .init(width: 50, height: 0))
                    label.font = UIFont(name: secondaryFontName, size: 10)
                    label.text = "MEAS."
                    label.textAlignment = .center
                    label.textColor = primaryTextColor
                    return label
                }()
                
                let itemLabel: UILabel = {
                    let label = UILabel()
                    label.anchor()
                    label.font = UIFont(name: secondaryFontName, size: 10)
                    label.text = "ITEM"
                    label.textColor = primaryTextColor
                    return label
                }()
                
                stackView.addArrangedSubview(quantityLabel)
                stackView.addArrangedSubview(measurementLabel)
                stackView.addArrangedSubview(itemLabel)
                
                return stackView
            }()
            
            view.addSubview(ingredientsLabel)
            view.addSubview(promptStack)
            
            ingredientsLabel.anchor(top: view.topAnchor,
                                    leading: view.leadingAnchor,
                                    trailing: view.trailingAnchor,
                                    padding: .init(top: 5, left: 5, bottom: 0, right: 5))
            
            promptStack.anchor(top: ingredientsLabel.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               bottom: view.bottomAnchor,
                               padding: .init(top: 2, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        return ingredientHeaderView
    }
    
    func layoutIngredientCell(withIngredient ingredient: RecipeIngredient) {
        clearCell()
        
        if ingredient.quantity != "" && ingredient.item != "" {
            quantityField.text = ingredient.quantity
            selectedMeasurement = ingredient.unitOfMeasurement
            measurementField.text = ingredient.unitOfMeasurement.shortHandNotation
            itemField.text = ingredient.item
        }
        
        let ingredientStack: UIStackView = {
            let stackView = UIStackView()
            stackView.alignment = .fill
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.spacing = 5
            
            stackView.addArrangedSubview(quantityField)
            stackView.addArrangedSubview(measurementField)
            stackView.addArrangedSubview(itemField)
            
            return stackView
        }()
        
        self.measurementField.inputView = self.measurementPicker
        self.measurementPicker.anchor()
        self.measurementPicker.dataPicker.dataSource = self
        self.measurementPicker.dataPicker.delegate = self
        self.measurementPicker.cancelButton.addTarget(self, action: #selector(pickerControlButtonPressed(_:)), for: .touchUpInside)
        self.measurementPicker.doneButton.addTarget(self, action: #selector(pickerControlButtonPressed(_:)), for: .touchUpInside)
        
        self.addSubview(ingredientStack)
        ingredientStack.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutIngredientAddCell() {
        clearCell()
        
        let addLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "Add Ingredient"
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            return label
        }()
        self.addSubview(addLabel)
        addLabel.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    //--------------------------------
    // MARK: - LAYOUT FOR INSTRUCTIONS
    //--------------------------------
    func layoutInstructionCellHeader() -> UIView {
        let instructionsView: UIView = {
            let view = UIView()
            view.backgroundColor = primaryColor
            
            let instructionsLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: fontName, size: largeFontSize)
                label.text = "Instructions"
                label.textAlignment = .center
                label.textColor = primaryTextColor
                return label
            }()
            
            view.addSubview(instructionsLabel)
            instructionsLabel.fillTo(view, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
            return view
        }()
        return instructionsView
    }
    
    func layoutInstructionCell(withInstruction instruction: String) {
        clearCell()
        
        if instruction != "" {
            instructionView.text = instruction
        }
        
        self.addSubview(instructionView)
        instructionView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func layoutInstructionAddCell() {
        clearCell()
        
        let addLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: fontName, size: largeFontSize)
            label.text = "Add Instruction"
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            return label
        }()
        self.addSubview(addLabel)
        addLabel.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    //---------------------
    // MARK: - DATA METHODS
    //---------------------
    func getRecipeIngredient() -> RecipeIngredient? {
        guard let quantity = self.quantityField.text, quantity != "" else { return nil }
        guard let item = self.itemField.text, item != "" else { return nil }
        let selectedMeasurement = self.selectedMeasurement
        
        let recipeIngredient = RecipeIngredient(quantity: quantity, unitOfMeasurement: selectedMeasurement, item: item)
        return recipeIngredient
    }
    
    func getInstruction() -> String? {
        guard let instruction = instructionView.text else { return nil }
        return instruction
    }
}

//-------------------------------------------
// MARK: - PICKERVIEW DATASOURCE AND DELEGATE
//-------------------------------------------
extension RecipeCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { return 30 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return allMeasurements.count }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel: UILabel = {
            let label = UILabel()
            label.addBorder(clipsToBounds: false)
            label.addLightShadows()
            label.backgroundColor = secondaryColor
            label.font = UIFont(name: secondaryFontName, size: smallerFontSize)
            label.text = allMeasurements[row].rawValue
            label.textAlignment = .center
            label.textColor = secondaryTextColor
            return label
        }()
        return pickerLabel
    }

    @objc func pickerControlButtonPressed(_ sender: UIButton) {
        endEditing(true)
        
        if sender == measurementPicker.doneButton {
            let selectedRow = measurementPicker.dataPicker.selectedRow(inComponent: 0)
            selectedMeasurement = allMeasurements[selectedRow]
            self.measurementField.text = selectedMeasurement.shortHandNotation
        }
    }
}
