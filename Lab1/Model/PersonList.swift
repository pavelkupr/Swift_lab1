//
//  PersonList.swift
//  Lab1
//
//  Created by student on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class PersonList {
    
    //MARK: Properties
    private(set) var employees: [Employee]!
    
    private(set) var currSignInUser: Employee?
    
    let genderTypes = ["Male", "Female", "Other"]
    
    init(){
        loadData()
    }
    
    func addNewAdmin(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withPassword password: String, withPasswordRepeat passwordRepeat: String) -> String? {
        
        if let error = checkAllPersonData(withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email, withPassword: password, withPasswordRepeat: passwordRepeat){
            return error
        }
        
        let props: [String: Any] = [
            "name":name,
            "surname":surname,
            "email":email,
            "password":password,
            "gender":gender,
            "birthdate":birthdate,
            "info":"Hey, everyone!",
            "isAdmin":true
        ]
        
        if let employee = CoreDataManager.instance.addNewObject(withEntityName: "Employee", withProperties: props) as? Employee {
            employees.append(employee)
        }
        else {
            fatalError("Can't cast data from storage")
        }
        
        return nil
    }
    
    func addNewPerson(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withInfo info: String, withImage image: Data?) -> String? {
        
        if let error = checkChangablePersonData(withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email) {
            return error
        }
        
        var props: [String: Any] = [
            "name":name,
            "surname":surname,
            "gender":gender,
            "birthdate":birthdate,
            "email":email,
            "info":info,
            "isAdmin":false
        ]
        
        if let img = image {
            props["personImage"] = img
        }
        
        if let employee = CoreDataManager.instance.addNewObject(withEntityName: "Employee", withProperties: props) as? Employee {
            employees.append(employee)
        }
        else {
            fatalError("Can't cast data from storage")
        }
        
        return nil
    }
    
    func editPerson(withInstance person: Employee, withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withInfo info: String, withImage image: Data?) -> String? {
        
        if let error = checkChangablePersonData(withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email) {
            return error
        }
        person.name = name
        person.surname = surname
        
        var props: [String:Any] = [
            "name":name,
            "surname":surname,
            "gender":gender,
            "birthdate":birthdate,
            "email":email,
            "info":info
        ]
        
        if let img = image {
            props["personImage"] = img
            person.personImage = img as NSData
        }
        
        CoreDataManager.instance.editObject(withInstance: person, withProperties: props)
        
        return nil
    }
    
    func deletePerson(withInstance person: Employee) {
        
        CoreDataManager.instance.deleteObject(withInstance: person)
        
        guard let index = employees.firstIndex(of: person) else {
            fatalError("Array doesn't contain \(person)")
        }
        
        employees.remove(at: index)
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
        if let employees = CoreDataManager.instance.loadData(withEntityName: "Employee") as? [Employee] {
            self.employees = employees
        }
        else {
            fatalError("Can't cast data from storage")
        }
    }
    
    private func checkChangablePersonData(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String) -> String? {
        
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
        
        return error
    }
    
    private func checkAllPersonData(withName name: String, withSurname surname: String, withGender gender: String, withBirthdate birthdate: String, withEmail email: String, withPassword password: String, withPasswordRepeat passwordRepeat: String) -> String? {
        
        var error : String? = nil

        if password.count <= 7 {
            error = "Password must be longer than 7 symbols."
        }
        
        if password != passwordRepeat {
            error = (error == nil ? "Passwords must be equal." : error! + "\nPasswords must be equal.")
        }
        
        if let errMsg = checkChangablePersonData(withName: name, withSurname: surname, withGender: gender, withBirthdate: birthdate, withEmail: email) {
            error = (error == nil ? errMsg : error! + "\n" + errMsg)
        }
        
        return error
    }
}
