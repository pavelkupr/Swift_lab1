//
//  EmployeeSplitViewController.swift
//  Lab1
//
//  Created by Pavel on 4/29/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeeSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    var personList: PersonList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        self.maximumPrimaryColumnWidth = 512
        self.preferredPrimaryColumnWidthFraction = 0.5
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
