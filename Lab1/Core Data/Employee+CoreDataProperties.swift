//
//  Employee+CoreDataProperties.swift
//  Lab1
//
//  Created by student on 3/21/19.
//  Copyright © 2019 student. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var info: String?
    @NSManaged public var isAdmin: Bool
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var personImage: NSData?
    @NSManaged public var surname: String?
    @NSManaged public var birthdate: String?

}
