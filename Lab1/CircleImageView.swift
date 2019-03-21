//
//  CircleImageView.swift
//  Lab1
//
//  Created by student on 3/21/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircle()
    }
    
    //MARK: Private methods
    
    private func createCircle() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.gray.cgColor
    }
    
}
