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
        eventName.adjustsFontSizeToFitWidth = true
        eventName.text = currentEvent.name!
        nameLabel.text = currentLead.name
        partnerLabel.text = currentLead.partner
        dateLabel.text = currentLead.date
        locationLabel.text = currentLead.location
        phoneLabel.text = currentLead.phoneNum
        emailLabel.text = currentLead.email
        if currentLead.subscribe == true {
            contactLabel.text = "Yes"
        } else {
            contactLabel.text = "No"
        }
        commentsLabel.text = currentLead.comments
        
        navBarTitle.title = currentLead.name
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

