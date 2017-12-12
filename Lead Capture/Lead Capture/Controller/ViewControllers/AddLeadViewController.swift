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
    var delegate : AddLeadDelegate?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var infoField: UITextView!
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        createLead()
        resetForm()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let thankYouAlert = storyboard.instantiateViewController(withIdentifier: "ThankYouAlert") as! ThankYouAlertController
        thankYouAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        thankYouAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(thankYouAlert, animated: true, completion: nil)

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
    
    func createLead() {
        let newLead = Lead(context: PersistenceService.context)
        if nameField.text == "" {
            newLead.name = "No Name Given"
        } else {
            newLead.name = nameField.text
        }
        if dateField.text == "" {
            newLead.date = "No Date Given"
        } else {
            newLead.date = dateField.text
        }
        newLead.email = emailField.text
        newLead.phoneNum = phoneField.text
        newLead.comments = infoField.text
        newLead.createdOn = NSDate()
        newLead.leadID = UUID().uuidString
        newLead.event = self.currentEvent
        self.delegate?.addLead(lead: newLead)
    }
    
    func resetForm() {
        for view in self.view.subviews {
            if view is UITextField {
                let textField = view as? UITextField
                textField?.text = nil
            }
        }
        infoField.text = nil
    }

}

protocol AddLeadDelegate {
    func addLead(lead: Lead)
}

