//
//  Event.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/10/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import Foundation

class Event {
    var leads = [Lead]()
    let eventID = UUID().uuidString
    let createdOn : Date
    var name : String
    init(name: String) {
        self.name = name
        self.createdOn = Date()
    }
}
