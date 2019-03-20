//
//  SignInViewController.swift
//  Lab1
//
//  Created by student on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    //MARK: Properties
    
    var personList: PersonList!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    
    @IBAction func logIn(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)

        switch identifier {
        case "TableViewSegueFromSignIn":
            
            return personList.signIn(withEmail: emailField.text!, withPassword: passwordField.text!)
            
        default:
            fatalError("Unexpected segue")
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "TableViewSegueFromSignIn":
            guard segue.destination as? EmployeesTableViewController != nil else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    
}
