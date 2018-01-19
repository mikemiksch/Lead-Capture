//
//  ExpandedLeadDataCell.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/21/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class ExpandedLeadDataCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
