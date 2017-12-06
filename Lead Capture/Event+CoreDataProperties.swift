//
//  Event+CoreDataProperties.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/5/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var leads: NSObject?
    @NSManaged public var eventID: String?
    @NSManaged public var createdOn: NSDate?
    @NSManaged public var name: String?

}
