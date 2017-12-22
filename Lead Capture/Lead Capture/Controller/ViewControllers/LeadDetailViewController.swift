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
        navBarTitle.title = currentLead.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self.view)
            guard let phoneText = phoneLabel.text?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted) else { return }
            guard let phoneURL = URL(string: "tel://\(phoneText)") else { return }
            if phoneLabel.frame.contains(location) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func populateLabels() {
        nameLabel.text = currentLead.name
        dateLabel.text = currentLead.date
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
            phoneLabel.textColor = Settings.shared.accentColor
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

