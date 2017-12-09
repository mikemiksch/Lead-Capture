//
//  Event+CoreDataProperties.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/6/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var date: String?
    @NSManaged public var eventID: String?
    @NSManaged public var name: String?
    @NSManaged public var leads: NSSet?

}

// MARK: Generated accessors for lead
extension Event {

    @objc(addLeadObject:)
    @NSManaged public func addToLeads(_ value: Lead)

    @objc(removeLeadObject:)
    @NSManaged public func removeFromLeads(_ value: Lead)

    @objc(addLead:)
    @NSManaged public func addToLeads(_ values: NSSet)

    @objc(removeLead:)
    @NSManaged public func removeFromLeads(_ values: NSSet)

}
