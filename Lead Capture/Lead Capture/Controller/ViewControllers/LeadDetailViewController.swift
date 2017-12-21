//
//  LeadDetailViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class LeadDetailViewController: UIViewController {
    
    var currentEvent : Event!
    var currentLead : Lead!
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateLabels()
//
//        nameLabel.text = currentLead.name
//        partnerLabel.text = currentLead.partner
//        dateLabel.text = currentLead.date
//        locationLabel.text = currentLead.location
//        phoneLabel.text = currentLead.phoneNum
//        emailLabel.text = currentLead.email
//        if currentLead.subscribe == true {
//            contactLabel.text = "Yes"
//        } else {
//            contactLabel.text = "No"
//        }
//        commentsLabel.text = currentLead.comments
        
        navBarTitle.title = currentLead.name
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateLabels() {
        nameLabel.text = currentLead.name
        eventName.adjustsFontSizeToFitWidth = true
        eventName.text = currentEvent.name!
        
        if currentLead.partner != "" {
            partnerLabel.text = currentLead.partner
        } else {
            partnerLabel.text = "No Name Given"
        }
        
        if currentLead.location != "" {
            locationLabel.text = currentLead.location
        } else {
            locationLabel.text = "No Location Given"
        }
        
        if currentLead.phoneNum != "" {
            phoneLabel.text = currentLead.phoneNum
        } else {
            phoneLabel.text = "No Phone Number Given"
        }
        
        if currentLead.email != "" {
            emailLabel.text = currentLead.email
        } else {
            emailLabel.text = "No Email Given"
        }
        
        if !currentLead.subscribe {
            contactLabel.text = "No"
        } else {
            contactLabel.text = "Yes"
        }
        
        if currentLead.comments != "" {
            commentsLabel.text = currentLead.comments
        } else {
            commentsLabel.text = "No Additional Comments"
        }
    }

}

