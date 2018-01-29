//
//  LeadCell.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/11/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class LeadCell: UITableViewCell {

    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameField.adjustsFontSizeToFitWidth = true
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
