//
//  BirthField.swift
//  Lab1
//
//  Created by student on 3/21/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class BirthField: UITextField {
    
    let datePicker = UIDatePicker()
    var dateFormatter: DateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        connectDatePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        connectDatePicker()
    }
    
    //MARK: Private methods
    private func connectDatePicker(){
        dateFormatter.dateFormat = "dd/MM/yyyy"
        inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(BirthField.dismissPicker))
        inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(BirthField.dateChange(datePicker:)), for: .valueChanged)
        datePicker.maximumDate = Date()
    }
    
    @objc private func dateChange(datePicker: UIDatePicker) {
        text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func dismissPicker() {
        text = dateFormatter.string(from: datePicker.date)
        resignFirstResponder()
    }

}
