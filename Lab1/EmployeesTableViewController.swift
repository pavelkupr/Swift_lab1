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
    var currSignInUser: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(EmployeesTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

        if (visualList[indexPath.row].personImage != nil) {
            let convertedImage = UIImage(data: visualList[indexPath.row].personImage! as Data)
            cell.employeeImageView.image = convertedImage!
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 
        return indexPath.row != 0
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
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "Edit":
            if let editEmployeeVC = segue.destination as? EmployeeEditViewController{
                editEmployeeVC.personList = personList
                editEmployeeVC.currSignInUser = currSignInUser
            }
            else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue")
            
        }
    }
    
    //MARK: Private
    
    @objc private func back(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    private func updateVisualList() {
        
        visualList = []
        visualList.append(currSignInUser)
        
        for employee in personList.employees {
            if employee != currSignInUser {
                visualList.append(employee)
            }
        }
        tableView.reloadData()
    }
}
