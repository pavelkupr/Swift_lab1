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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.employeeImageView.layer.cornerRadius = employeeImageView.frame.size.width / 2
        self.employeeImageView.clipsToBounds = true
        self.employeeImageView.layer.borderWidth = 3.0
        self.employeeImageView.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
