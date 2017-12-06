////
////  LeadDetailViewController.swift
////  Lead Capture
////
////  Created by Mike Miksch on 11/15/17.
////  Copyright © 2017 Mike MIksch. All rights reserved.
////
//
//import UIKit
//
//class LeadDetailViewController: UIViewController {
//    
//    var currentLead : Lead!
//    
//    @IBOutlet weak var nameField: UILabel!
//    @IBOutlet weak var emailField: UILabel!
//    @IBOutlet weak var phoneField: UILabel!
//    @IBOutlet weak var dateField: UILabel!
//    @IBOutlet weak var infoField: UILabel!
//    @IBOutlet weak var navBarTitle: UINavigationItem!
//    
//    @IBAction func dismissButtonPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        nameField.text = currentLead.name
//        emailField.text = currentLead.email
//        phoneField.text = currentLead.phoneNum
//        dateField.text = currentLead.date
//        infoField.text = currentLead.comments
//        navBarTitle.title = currentLead.name
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

