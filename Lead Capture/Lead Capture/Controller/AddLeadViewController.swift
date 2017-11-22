//
//  AddLeadViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class AddLeadViewController: UIViewController {
    
    var currentEvent : Event!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var infoField: UITextView!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let newLead = Lead(eventID: currentEvent.eventID)
        newLead.name = nameField.text
        newLead.email = emailField.text
        newLead.phoneNum = phoneField.text
        print(dateField.text)
        newLead.comments = infoField.text
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = UIDatePicker()
        let toolBar = UIToolbar().ToolbarButtons(selection: #selector(self.dismissPicker))
        
        datePicker.datePickerMode = .date
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }

}
