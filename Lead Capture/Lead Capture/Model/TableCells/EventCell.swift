//
//  EventCell.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/11/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    

    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var eventNameField: UILabel!
    @IBOutlet weak var leadCountField: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventNameField.adjustsFontSizeToFitWidth = true
    }
}
