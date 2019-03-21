//
//  employeeEditViewController.swift
//  Lab1
//
//  Created by student on 3/19/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    
    var personList: PersonList!
    var editPerson: Employee?
    var isImageChanged = false
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var genderField: FieldWithPicker!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var infoView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.layer.borderColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        infoView.layer.borderWidth = 1.0
        infoView.layer.cornerRadius = 5.0
        
        deleteButton.isHidden = true
        
        genderField.picker.delegate = self
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
        
        if let person = editPerson {
            nameField.text = person.name
            surnameField.text = person.surname
            birthField.text = person.birthdate
            genderField.text = person.gender
            
            if let data = person.personImage {
                personImageView.image = UIImage(data: data as Data)
            }
            
            if !person.isAdmin || person == personList.currSignInUser {
               deleteButton.isHidden = false
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        personImageView.image = selectedImage
        isImageChanged = true
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
        view.endEditing(true)
    }
    
    //MARK: Actions
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        
        var data: Data? = nil
        
        if isImageChanged, let myImage = personImageView.image!.fixOrientation().pngData() {
            data = myImage
        }
        
        if let person = editPerson {
            
            if let error = personList.editPerson(withInstance: person, withName: nameField.text!, withSurname: surnameField.text!, withGender:  genderField.text!, withBirthdate:  birthField.text!, withImage: data) {
                errorLabel.text = error
            }
            else {
                navigationController?.popViewController(animated: true)
            }
        }
        else {
            if let error = personList.addNewPerson(withName: nameField.text!, withSurname: surnameField.text!, withGender: genderField.text!, withBirthdate: birthField.text!, withImage: data) {
                errorLabel.text = error
            }
            else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        nameField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("This controller is not inside a navigation controller.")
        }
    }
    
    //MARK: Private Methods
    

}
