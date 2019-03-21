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
    var visualList: [Employee]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationController = navigationController! as? EmployeeNavigationController else {
            fatalError("Unexpected navigation controller")
        }
        
        personList = navigationController.personList
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
            guard segue.destination as? EmployeeEditViewController != nil else {
                fatalError("Unexpected destination")
            }
            
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
            editEmployeeVC.editPerson = visualList[index.row]
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    //MARK: Actions
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Private

    private func updateVisualList() {
        
        visualList = [personList.currSignInUser!]

        visualList += personList.employees.filter { $0 != personList.currSignInUser && $0.isAdmin }
        visualList += personList.employees.filter { !$0.isAdmin }
        
        tableView.reloadData()
    }
}
