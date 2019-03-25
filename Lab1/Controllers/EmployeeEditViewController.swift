//
//  employeeEditViewController.swift
//  Lab1
//
//  Created by student on 3/19/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //MARK: Properties
    
    var personList: PersonList!
    var editPerson: Employee?
    var isImageChanged = false
    var isKeyboardShowed = false
    let spacing: CGFloat = CGFloat(8)
    let alertController = UIAlertController(title: "Are you sure?", message: "Delete current person?", preferredStyle: .alert)
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var genderField: FieldWithPicker!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var infoView: UITextView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var editNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { UIAlertAction in
            
            if self.personList.currSignInUser == self.editPerson {
                
                self.personList.deletePerson(withInstance: self.editPerson!)
                self.navigationController?.popToRootViewController(animated: true)
            }
            else {
                self.personList.deletePerson(withInstance: self.editPerson!)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        infoView.layer.borderColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        infoView.layer.borderWidth = 1.0
        infoView.layer.cornerRadius = 5.0
        
        deleteButton.isHidden = true
        
        genderField.picker.delegate = self
        nameField.delegate = self
        surnameField.delegate = self
        genderField.delegate = self
        emailField.delegate = self
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
        
        if let person = editPerson {
            
            nameField.text = person.name
            surnameField.text = person.surname
            birthField.text = person.birthdate
            genderField.text = person.gender
            emailField.text = person.email
            infoView.text = person.info
            
            if person.isAdmin {
                editNavItem.title = "Admin"
            }
            
            if let data = person.personImage {
                personImageView.image = UIImage(data: data as Data)
            }
            
            if !person.isAdmin || person == personList.currSignInUser {
                deleteButton.isHidden = false
            }
            else {
                saveBarButton.isEnabled = false
                nameField.isUserInteractionEnabled = false
                surnameField.isUserInteractionEnabled = false
                birthField.isUserInteractionEnabled = false
                genderField.isUserInteractionEnabled = false
                emailField.isUserInteractionEnabled = false
                infoView.isUserInteractionEnabled = false
                personImageView.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let responder = view.firstResponder, !isKeyboardShowed {
            
            guard let respCoord = responder.getCoordRelative(toView: view) else {
                fatalError()
            }
            let shift = (respCoord.y + responder.bounds.height + spacing) - keyboardSize.origin.y
            view.frame.origin.y -= shift > 0 ? shift : 0
            isKeyboardShowed = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardShowed {
            self.view.frame.origin.y = 0
            isKeyboardShowed = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == genderField, textField.text!.isEmpty {
            textField.text = personList.genderTypes.first
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    
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
    }
    
    //MARK: Actions
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        
        var data: Data? = nil
        
        if isImageChanged, let myImage = personImageView.image!.fixOrientation().pngData() {
            data = myImage
        }
        
        if let person = editPerson {
            
            if let error = personList.editPerson(withInstance: person, withName: nameField.text!, withSurname: surnameField.text!, withGender:  genderField.text!, withBirthdate:  birthField.text!, withEmail: emailField.text!, withInfo: infoView.text!, withImage: data) {
                view.endEditing(true)
                errorLabel.text = error
            }
            else {
                navigationController?.popViewController(animated: true)
            }
        }
        else {
            if let error = personList.addNewPerson(withName: nameField.text!, withSurname: surnameField.text!, withGender: genderField.text!, withBirthdate: birthField.text!, withEmail: emailField.text!, withInfo: infoView.text!, withImage: data) {
                view.endEditing(true)
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
    
    @IBAction func deletePerson(_ sender: UIButton) {
        present(alertController, animated: true, completion: nil)
    }
    
}
