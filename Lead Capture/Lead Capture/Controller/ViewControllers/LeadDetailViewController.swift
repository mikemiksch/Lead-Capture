//
//  LeadDetailViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit
import MessageUI

class LeadDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
    
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    //    @IBAction func dismissButtonPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateLabels()
        navBarTitle.title = currentLead.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        populateLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationViewController = segue.destination as? AddLeadViewController {
            destinationViewController.currentLead = currentLead
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self.view)
            guard let phone = currentLead.phoneNum else { return }
            guard let email = currentLead.email else { return }
            guard let phoneURL = URL(string: "tel://\(phone)") else { return }
            
            if phoneLabel.frame.contains(location) && currentLead.phoneNum != "" {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
            
            if emailLabel.frame.contains(location) && currentLead.email != "" {
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([email])
                    present(mail, animated: true, completion: nil)
                } else {
                    print("Cannot send mail from this device")
                }
            }
        }
    }
    
    func populateLabels() {
//        nameLabel.text = currentLead.name
//        dateLabel.text = currentLead.date
        eventName.adjustsFontSizeToFitWidth = true
        eventName.text = currentEvent.name!
        
        if currentLead.name != "" {
            nameLabel.text = currentLead.name
        } else {
            nameLabel.text = "No Name Given"
        }
        
        if currentLead.date != "" {
            dateLabel.text = currentLead.date
        } else {
            dateLabel.text = "No Date Given"
        }
        
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
            emailLabel.textColor = Settings.shared.accentColor
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}

