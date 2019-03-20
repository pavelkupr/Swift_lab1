//
//  ViewController.swift
//  Lab1
//
//  Created by student on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    //MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "SignIn":
            guard segue.destination as? SignInViewController != nil else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        case "SignUp":
            guard segue.destination as? SignUpViewController != nil else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue")
            
        }
     }
    

}

