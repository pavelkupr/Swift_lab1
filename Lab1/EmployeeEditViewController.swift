//
//  employeeEditViewController.swift
//  Lab1
//
//  Created by student on 3/19/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    var personList: PersonList!
    var editPerson: Employee?
    var isImageChaged = false
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
        self.personImageView.clipsToBounds = true
        self.personImageView.layer.borderWidth = 3.0
        self.personImageView.layer.borderColor = UIColor.gray.cgColor
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
        if let person = editPerson {
            nameField.text = person.name
            surnameField.text = person.surname
            
            if let data = person.personImage {
                personImageView.image = UIImage(data: data as Data)
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
        isImageChaged = true
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        
        var data: Data? = nil
        
        if isImageChaged, let myImage = personImageView.image!.fixOrientation().pngData() {
            data = myImage
        }
        
        if let person = editPerson {
            
            if let error = personList.editPerson(withInstance: person, withName: nameField.text!, withSurname: surnameField.text!, withImage: data) {
                errorLabel.text = error
            }
            else {
                navigationController?.popViewController(animated: true)
            }
        }
        else {
            if let error = personList.addNewPerson(withName: nameField.text!, withSurname: surnameField.text!, withImage: data) {
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
