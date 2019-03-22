//
//  EmployeeTableViewCell.swift
//  Lab1
//
//  Created by student on 3/19/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var employeeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var userTypeField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
