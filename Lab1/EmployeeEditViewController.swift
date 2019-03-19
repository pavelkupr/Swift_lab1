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
    var currSignInUser: Employee!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        let newButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EmployeeEditViewController.cancel(sender:)))
        
        self.navigationItem.leftBarButtonItem = newButton
        self.personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
        self.personImageView.clipsToBounds = true
        self.personImageView.layer.borderWidth = 3.0
        self.personImageView.layer.borderColor = UIColor.gray.cgColor
        
        nameField.text = currSignInUser.name
        surnameField.text = currSignInUser.surname
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        personImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        
        var data: Data? = nil
        
        if let myImage = personImageView.image!.pngData() {
            data = myImage
        }
        
        if let error = personList?.editPerson(withInstance: currSignInUser, withName: nameField.text!, withSurname: surnameField.text!, withImage: data) {
            errorLabel.text = error
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        nameField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    @objc private func cancel(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}
