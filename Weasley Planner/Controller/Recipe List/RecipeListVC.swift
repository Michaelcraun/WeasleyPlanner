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
    let titleBar: TitleBar = {
        let bar = TitleBar()
        bar.subtitle = "Recipe List"
        return bar
    }()
    
    //MARK: Data Variables
    

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleBar.delegate = self
        
        
    }
}
