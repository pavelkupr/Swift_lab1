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
    
    var personList: PersonList?
    
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
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
