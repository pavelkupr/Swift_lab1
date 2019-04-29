//
//  User.swift
//  Lab1
//
//  Created by Pavel on 4/28/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class User {
    
    var email: String
    var gender: String
    var info: String
    var isAdmin: Bool
    var name: String
    var password: String?
    var personImage: NSData?
    var surname: String
    var birthdate: String
    
    init(email: String, gender: String, info: String, isAdmin: Bool, name: String,
         password: String?, personImage: NSData?, surname: String, birthdate: String) {
        self.email=email
        self.gender=gender
        self.info=info
        self.isAdmin=isAdmin
        self.name=name
        self.password=password
        self.personImage=personImage
        self.surname=surname
        self.birthdate=birthdate
    }
}
