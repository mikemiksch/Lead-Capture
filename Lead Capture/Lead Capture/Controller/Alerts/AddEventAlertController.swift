//
//  AddEventAlertController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/8/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class AddEventAlertController: UIViewController {

    var currentEvent : Event?
    var delegate : AddEventDelegate?
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func dateEditingDidBegin(_ sender: UITextField) {
        sender.text = dateFormatter.string(from: Date())
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        if let currentEvent = currentEvent {
            currentEvent.name = nameField.text
            currentEvent.date = dateField.text
        } else {
            self.delegate?.addEvent(name: nameField.text!, date: dateField.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyFormatting()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let datePicker = UIDatePicker()
        let toolBar = UIToolbar().ToolbarButtons(selection: #selector(self.dismissPicker))
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolBar
        
        if let currentEvent = currentEvent {
            nameField.text = currentEvent.name
            dateField.text = currentEvent.date
        }
    }
    
    func applyFormatting() {
        viewBox.layer.cornerRadius = 10
        viewBox.layer.borderColor = Settings.shared.accentColor.cgColor
        viewBox.layer.borderWidth = 1
        viewBox.layer.shadowColor = UIColor.black.cgColor
        viewBox.layer.shadowOpacity = 0.5
        viewBox.layer.shadowOffset = CGSize.zero
        viewBox.layer.shadowRadius = 5
        viewBox.layer.shadowPath = UIBezierPath(rect: viewBox.bounds).cgPath
        cancelButton.layer.cornerRadius = 10
        createButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = Settings.shared.accentColor
        cancelButton.setTitleColor(Settings.shared.backgroundColor, for: .normal)
        createButton.backgroundColor = Settings.shared.backgroundColor
        createButton.setTitleColor(Settings.shared.accentColor, for: .normal)
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

protocol AddEventDelegate {
    func addEvent(name: String, date: String)
}
