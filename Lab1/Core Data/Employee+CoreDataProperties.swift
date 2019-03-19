//
//  Employee+CoreDataProperties.swift
//  Lab1
//
//  Created by Pavel on 3/18/19.
//  Copyright © 2019 student. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?

}
