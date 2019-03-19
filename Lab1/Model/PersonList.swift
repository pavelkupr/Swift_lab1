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
    
    init(){
        loadData()
    }
    
    func addNewPerson(withName name: String, withSurname surname: String, withEmail email: String, withPassword password: String, withPasswordRepeat passwordRepeat: String) -> String? {
        
        if let error = checkAllPersonData(withName: name, withSurname: surname, withEmail: email, withPassword: password, withPasswordRepeat: passwordRepeat){
            return error
        }
        
        let props: [String: Any] = [
            "name":name,
            "surname":surname,
            "email":email,
            "password":password
        ]
        
        if let employee = CoreDataManager.instance.addNewObject(withEntityName: "Employee", withProperties: props) as? Employee {
            employees.append(employee)
        }
        else {
            fatalError("Can't cast data from storage")
        }
        
        return nil
    }
    
    func editPerson(withInstance person: Employee, withName name: String, withSurname surname: String, withImage image: Data?) -> String? {
        
        if let error = checkChangablePersonData(withName: name, withSurname: surname) {
            return error
        }
        
        var props: [String:Any] = [
            "name":name,
            "surname":surname
        ]
        
        if image != nil {
            props = [
                "name":name,
                "surname":surname,
                "personImage":image!]
        }
        
        CoreDataManager.instance.editObject(withInstance: person, withProperties: props)
        
        loadData()
        
        return nil
    }
    
    func deletePerson(withInstance person: Employee) {
        
        CoreDataManager.instance.deleteObject(withInstance: person)
        loadData()
    }
    
    func getPerson(withEmail email: String, withPassword pass: String) -> Employee? {
        
        for employee in employees {
            if employee.email == email, employee.password == pass{
                return employee
            }
        }
        
        return nil
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
    
    private func checkChangablePersonData(withName name: String, withSurname surname: String) -> String? {
        
        var error : String? = nil
        
        if name.count < 1 || surname.count < 1 {
            error = "Name and surname must contain 1 or more symbols."
        }
        
        return error
    }
    
    private func checkAllPersonData(withName name: String, withSurname surname: String, withEmail email: String, withPassword password: String, withPasswordRepeat passwordRepeat: String) -> String? {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        var error : String? = nil

        if password.count <= 7 {
            error = "Password must be longer than 7 symbols."
        }
        
        if password != passwordRepeat {
            error = (error == nil ? "Passwords must be equal." : error! + "\nPasswords must be equal.")
        }
        
        if !emailPredicate.evaluate(with: email) {
            error = (error == nil ? "E-mail must be correct." : error! + "\nE-mail must be correct.")
        }
        
        if let errMsg = checkChangablePersonData(withName: name, withSurname: surname) {
            error = (error == nil ? errMsg : error! + "\n" + errMsg)
        }
        
        return error
    }
}
