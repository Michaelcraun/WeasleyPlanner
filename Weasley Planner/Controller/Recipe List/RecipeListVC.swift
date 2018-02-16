//
//  RecipeListVC.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/11/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class RecipeListVC: UIViewController {
    private let identifier = "showRecipeList"
    
    //MARK: UI Variables
    let titleBar = TitleBar()
    
    //MARK: Data Variables
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        
    }
}
