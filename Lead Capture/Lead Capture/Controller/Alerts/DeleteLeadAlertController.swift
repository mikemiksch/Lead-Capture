//
//  DeleteLeadAlertController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/8/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class DeleteLeadAlertController: UIViewController {

    var lead : Lead!
    var index : Int!
    var delegate : DeleteLeadDelegate?
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteLead(index: index, lead: lead)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

protocol DeleteLeadDelegate {
    func deleteLead(index: Int, lead: Lead)
}
