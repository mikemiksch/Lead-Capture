//
//  ExpandedLeadData.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/21/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import Foundation

class ExpandedLeadData {
    var lead: Lead!
    var expanded: Bool!
    
    init(lead: Lead, expanded: Bool){
        self.lead = lead
        self.expanded = expanded
    }
}
