//
//  FieldWithPicker.swift
//  Lab1
//
//  Created by student on 3/21/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class FieldWithPicker: UITextField {
    
    let picker = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inputView = picker
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inputView = picker
    }

}
