//
//  PersonList.swift
//  Lab1
//
//  Created by student on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import Firebase

class PersonList {
    
    //MARK: Properties
    private(set) var employees = [User]()
    
    private(set) var currSignInUser: User?
    
    let genderTypes = ["Male", "Female", "Other"]
    
    init(){
        loadData()
    }
    
    func addNewAdmin(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withPassword password: String, withPasswordRepeat passwordRepeat: String) -> String? {
        
        if let error = checkAdminData(withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email, withPassword: password, withPasswordRepeat: passwordRepeat){
            return error
        }
        
        let newDocument = email
        (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
            "user_name": name,
            "user_surname": surname,
            "user_gender": gender,
            "user_date_of_birth": birthdate,
            "user_email": email,
            "user_password": password,
            "user_about": "Hey, everyone!",
            "user_is_admin": true
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
        
        employees.append(User(email: email,
             gender: gender,
             info: "Hey, everyone!",
             isAdmin: true,
             name: name,
             password: password,
             personImage: nil,
             surname: surname,
             birthdate: birthdate))
        
        return nil
    }
    
    func addNewPerson(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withInfo info: String, withImage image: Data?) -> String? {
        
        if let error = checkPersonData(withInstance: nil, withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email) {
            return error
        }

        let newDocument = email
        if let img = image {
            (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
                "user_name": name,
                "user_surname": surname,
                "user_gender": gender,
                "user_date_of_birth": birthdate,
                "user_email": email,
                "user_about": info,
                "user_image": img,
                "user_is_admin": false
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        } else {
            (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
                "user_name": name,
                "user_surname": surname,
                "user_gender": gender,
                "user_date_of_birth": birthdate,
                "user_email": email,
                "user_about": info,
                "user_is_admin": false
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        }
        
        employees.append(User(email: email,
                              gender: gender,
                              info: "Hey, everyone!",
                              isAdmin: true,
                              name: name,
                              password: nil,
                              personImage: image == nil ? nil : NSData(data: image!),
                              surname: surname,
                              birthdate: birthdate))

        return nil
    }
    
    func editPerson(withInstance person: User, withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withInfo info: String, withImage image: Data?) -> String? {
        
        if let error = checkPersonData(withInstance: person, withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email) {
            return error
        }
        (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(person.email).delete()
        let newDocument = email
        if person.isAdmin {
            if let img = image {
                (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
                    "user_name": name,
                    "user_surname": surname,
                    "user_gender": gender,
                    "user_date_of_birth": birthdate,
                    "user_email": email,
                    "user_about": info,
                    "user_image": img,
                    "user_password": person.password!,
                    "user_is_admin": true
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                }
            } else {
                (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
                    "user_name": name,
                    "user_surname": surname,
                    "user_gender": gender,
                    "user_date_of_birth": birthdate,
                    "user_email": email,
                    "user_about": info,
                    "user_password": person.password!,
                    "user_is_admin": true
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                }
            }
        } else {
            if let img = image {
                (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
                    "user_name": name,
                    "user_surname": surname,
                    "user_gender": gender,
                    "user_date_of_birth": birthdate,
                    "user_email": email,
                    "user_about": info,
                    "user_image": img,
                    "user_is_admin": false
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                }
            } else {
                (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(newDocument).setData([
                    "user_name": name,
                    "user_surname": surname,
                    "user_gender": gender,
                    "user_date_of_birth": birthdate,
                    "user_email": email,
                    "user_about": info,
                    "user_is_admin": false
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                }
            }
        }
      person.email = email
      person.gender = gender
      person.info = info
      person.name = name
      person.personImage = image == nil ? nil : NSData(data: image!)
      person.surname = surname
      person.birthdate = birthdate
        
        return nil
    }
    
    func deletePerson(withInstance person: User) {
        
        (UIApplication.shared.delegate as! AppDelegate).db.collection("users").document(person.email).delete()
        employees.removeAll{$0.email == person.email}
    }
    
    func signIn(withEmail email: String, withPassword pass: String) -> Bool {
        
        for employee in employees {
            if employee.email == email, employee.password == pass{
                currSignInUser = employee
                return true
            }
        }
        
        return false
    }
    
    //MARK: Private Methods
    
    private func loadData() {
        
        (UIApplication.shared.delegate as! AppDelegate).db.collection("users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.employees.removeAll()
            print("Doc count - \(documents.count)")
            for document in documents {
                if document.exists {
                    self.employees.append(User(email: document.get("user_email") as! String,
                                          gender: document.get("user_gender") as! String,
                                          info: document.get("user_about") as! String,
                                          isAdmin: document.get("user_is_admin") as! Bool,
                                          name: document.get("user_name") as! String,
                                          password: document.get("user_password") as? String,
                                          personImage: document.get("user_image") as? NSData,
                                          surname: document.get("user_surname") as! String,
                                          birthdate: document.get("user_date_of_birth") as! String))
                }
            }
        }
    }
    
    private func checkPersonData(withInstance person: User?, withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String) -> String? {
        
        var error : String? = nil
        let datePredicate = NSPredicate(format:"SELF MATCHES %@", "[0-3][0-9]/[0-1][0-9]/[0-9]{4}")
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        
        if name.count < 1 || surname.count < 1 {
            error = "Name and surname must contain 1 or more symbols."
        }
        
        if !genderTypes.contains(gender) {
            error = (error == nil ? "Choose gender." : error! + "\nChoose gender.")
        }
        
        if !datePredicate.evaluate(with: birthdate) {
            error = (error == nil ? "Choose birthdate." : error! + "\nChoose birthdate.")
        }
        
        if !emailPredicate.evaluate(with: email) {
            error = (error == nil ? "E-mail must be correct." : error! + "\nE-mail must be correct.")
        }
        else if (person == nil || person?.email != email) && employees.contains(where: {$0.email == email}) {
            error = (error == nil ? "E-mail already exists." : error! + "\nE-mail already exists.")
        }
        
        return error
    }
    
    private func checkAdminData(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withPassword password: String, withPasswordRepeat passwordRepeat: String) -> String? {
        
        var error : String? = nil

        if password.count <= 7 {
            error = "Password must be longer than 7 symbols."
        }
        
        if password != passwordRepeat {
            error = (error == nil ? "Passwords must be equal." : error! + "\nPasswords must be equal.")
        }
        
        if let errMsg = checkPersonData(withInstance: nil, withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email) {
            error = (error == nil ? errMsg : error! + "\n" + errMsg)
        }
        
        return error
    }
}
