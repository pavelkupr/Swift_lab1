//
//  EmployeesTableViewController.swift
//  Lab1
//
//  Created by Pavel on 3/19/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeesTableViewController: UITableViewController {

    //MARK: Properties
    
    var personList: PersonList!
    var visualList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let splitController = splitViewController! as? EmployeeSplitViewController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = splitController.personList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateVisualList()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return visualList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as? EmployeeTableViewCell else {
            
            fatalError("Unexpected type of cell")
        }
        
        cell.nameLabel.text = visualList[indexPath.row].name
        cell.surnameLabel.text = visualList[indexPath.row].surname
        cell.genderLabel.text = "Gender: "+visualList[indexPath.row].gender
        cell.ageLabel.text = "Age: "+String(getAge(birthDate: visualList[indexPath.row].birthdate))
        if visualList[indexPath.row].email == personList.currSignInUser?.email {
            cell.userTypeField.text = "Current Admin"
        }
        else {
            cell.userTypeField.text = visualList[indexPath.row].isAdmin ? "Admin" : "Employee"
        }
        
        if let data = visualList[indexPath.row].personImage {
            cell.employeeImageView.image = UIImage(data: data as Data)
        }
        else {
            cell.employeeImageView.image = UIImage(named: "Placeholder")
        }
        
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return !visualList[indexPath.row].isAdmin
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            personList.deletePerson(withInstance: visualList.remove(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "Add":
            guard let editEmployeeVC = segue.destination as? EmployeeEditViewController else {
                fatalError("Unexpected destination")
            }
            editEmployeeVC.tvc = self
            
        case "Edit":
            guard let editEmployeeVC = segue.destination as? EmployeeEditViewController else {
                fatalError("Unexpected destination")
            }
            
            guard let cell = sender as? EmployeeTableViewCell else {
                fatalError("Unexpected sender")
            }
            
            guard let index = tableView.indexPath(for: cell) else {
                fatalError("Cell doesn't exist")
            }
            editEmployeeVC.tvc = self
            editEmployeeVC.editPerson = visualList[index.row]
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    //MARK: Actions
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private

    func updateVisualList() {
        
        visualList = [personList.currSignInUser!]

        visualList += personList.employees.filter { $0.email != personList.currSignInUser?.email && $0.isAdmin }
        visualList += personList.employees.filter { !$0.isAdmin }
        
        tableView.reloadData()
    }
    
    private func getAge(birthDate: String) -> Int {
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let birthday = dateFormatter.date(from: birthDate)
        let calendar = Calendar.current
        
        return calendar.dateComponents([.year], from: birthday!, to: now).year!
    }
}
