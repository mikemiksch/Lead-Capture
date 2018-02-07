//
//  Event+CoreDataProperties.swift
//  Lead Capture
//
//  Created by Mike Miksch on 2/1/18.
//  Copyright © 2018 Mike MIksch. All rights reserved.
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
    @NSManaged public var sortKey: String?
    @NSManaged public var leads: NSSet?
    @NSManaged public var flagged: Bool

}

// MARK: Generated accessors for leads
extension Event {

    @objc(addLeadsObject:)
    @NSManaged public func addToLeads(_ value: Lead)

    @objc(removeLeadsObject:)
    @NSManaged public func removeFromLeads(_ value: Lead)

    @objc(addLeads:)
    @NSManaged public func addToLeads(_ values: NSSet)

    @objc(removeLeads:)
    @NSManaged public func removeFromLeads(_ values: NSSet)

}
