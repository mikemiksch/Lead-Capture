//
//  Lead.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/10/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import Foundation

class Lead {
    let leadID = UUID().uuidString
    let eventID : String
    var name : String?
    var email : String?
    var date : String?
    var phoneNum : String?
    var comments: String?
    init(eventID: String) {
        self.eventID = eventID
    }
}
