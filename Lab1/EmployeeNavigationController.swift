//
//  EmployeeNavigationController.swift
//  Lab1
//
//  Created by student on 3/20/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeeNavigationController: UINavigationController {

    
    //MARK: Properties
    
    var personList = PersonList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presentingViewController == nil {
            print("nil")
        }
        
        // Do any additional setup after loading the view.
    }

}
