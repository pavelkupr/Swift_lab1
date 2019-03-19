//
//  SignUpViewController.swift
//  Lab1
//
//  Created by Pavel on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: Properties
    
    var personList: PersonList!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordRepeatField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        var result = true
        
        switch identifier {
        case "TableViewSegue":
            if let error = personList?.addNewPerson(withName: nameField.text!, withSurname: surnameField.text!, withEmail: emailField.text!, withPassword: passwordField.text!, withPasswordRepeat: passwordRepeatField.text!) {
                errorLabel.text = error
                result = false
            }
            else {
                errorLabel.text = ""
            }
        default:
            fatalError("Unexpected segue")
        }
        
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "TableViewSegue":
            if let employeeTVC = segue.destination as? EmployeesTableViewController{
                employeeTVC.personList = personList
                employeeTVC.currSignInUser = personList?.getPerson(withEmail: emailField.text!, withPassword: passwordField.text!)
            }
            else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
 

}
