//
//  CustomButton.swift
//  Lab1
//
//  Created by Pavel on 3/22/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCustomStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setCustomStyle()
    }
    
    //MARK: Private methods
    private func setCustomStyle(){
        backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        setTitleColor(UIColor.darkGray, for: .normal)
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.darkGray.cgColor
    }

}
