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
    
    private var signedUser: Employee?
    var personList: PersonList!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            guard let person = personList.getPerson(withEmail: emailField.text!, withPassword: passwordField.text!) else {
                errorLabel.text = "User doesn't exist"
                return false
            }
            signedUser = person
            
        default:
            fatalError("Unexpected segue")
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "TableViewSegueFromSignIn":
            if let employeeTVC = segue.destination as? EmployeesTableViewController{
                employeeTVC.personList = personList
                employeeTVC.currSignInUser = signedUser
            }
            else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    
}
