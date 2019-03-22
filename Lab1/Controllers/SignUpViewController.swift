//
//  SignUpViewController.swift
//  Lab1
//
//  Created by Pavel on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //MARK: Properties
    
    var personList: PersonList!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordRepeatField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var genderField: FieldWithPicker!
    @IBOutlet weak var birthField: BirthField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        genderField.picker.delegate = self
        genderField.delegate = self
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordRepeatField.delegate = self
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == genderField, textField.text!.isEmpty {
            textField.text = personList.genderTypes.first
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return personList.genderTypes.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return personList.genderTypes[row]
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = personList.genderTypes[row]
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)

        var result = true
        
        switch identifier {
            
        case "TableViewSegue":
            if let error = personList?.addNewAdmin(withName: nameField.text!, withSurname: surnameField.text!, withGender:  genderField.text!, withBirthdate: birthField.text!, withEmail: emailField.text!, withPassword: passwordField.text!, withPasswordRepeat: passwordRepeatField.text!) {
                
                view.endEditing(true)
                errorLabel.text = error
                result = false
            }
            else {
                guard personList.signIn(withEmail: emailField.text!, withPassword: passwordField.text!) == true else {
                    fatalError("Can't sign in with created user")
                }
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
            guard segue.destination as? EmployeesTableViewController != nil else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
 

}
