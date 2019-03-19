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
    
    var personList: PersonList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personList = PersonList()
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "SignIn":
            break
            
        case "SignUp":
            if let signUpVC = segue.destination as? SignUpViewController{
                signUpVC.personList = personList
            }
            else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            break
            
        }
     }
    

}

