//
//  Lead+CoreDataProperties.swift
//  Lead Capture
//
//  Created by Mike Miksch on 1/26/18.
//  Copyright © 2018 Mike MIksch. All rights reserved.
//
//

import Foundation
import CoreData


extension Lead {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lead> {
        return NSFetchRequest<Lead>(entityName: "Lead")
    }

    @NSManaged public var comments: String?
    @NSManaged public var createdOn: NSDate?
    @NSManaged public var date: String?
    @NSManaged public var email: String?
    @NSManaged public var eventID: String?
    @NSManaged public var image: NSData?
    @NSManaged public var leadID: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var partner: String?
    @NSManaged public var phoneNum: String?
    @NSManaged public var subscribe: Bool
    @NSManaged public var flagged: Bool
    @NSManaged public var event: Event?

}
