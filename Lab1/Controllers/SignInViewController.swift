//
//  SignInViewController.swift
//  Lab1
//
//  Created by student on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    
    var personList: PersonList!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        
        var result = false
        
        switch identifier {
        case "SignUp":
            result = true
            
        case "TableViewSegueFromSignIn":
            if personList.signIn(withEmail: emailField.text!, withPassword: passwordField.text!) {
                emailField.text = ""
                passwordField.text = ""
                result = true
            }
            else {
                view.endEditing(true)
                errorLabel.text = "That user doesn't exist"
            }
            
        default:
            fatalError("Unexpected segue")
        }
        
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "SignUp":
            guard segue.destination as? SignUpViewController != nil else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        case "TableViewSegueFromSignIn":
            guard let dest = segue.destination as? EmployeeSplitViewController else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            dest.personList = personList
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    
}
