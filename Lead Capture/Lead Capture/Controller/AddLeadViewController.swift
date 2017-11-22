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
//        let newLead = Lead(eventID: currentEvent.eventID)
        let newLead = Lead(eventID: UUID().uuidString)
        newLead.name = nameField.text
        newLead.email = emailField.text
        newLead.phoneNum = phoneField.text
        newLead.date = dateField.text
        newLead.comments = infoField.text
        print(String(describing: newLead))
        
    }
    
    @IBAction func dateEditingDidBegin(_ sender: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        sender.text = dateFormatter.string(from: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = UIDatePicker()
        let toolBar = UIToolbar().ToolbarButtons(selection: #selector(self.dismissPicker))
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func dateValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }

}
