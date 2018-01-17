//
//  DeleteEventAlertController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/8/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class DeleteEventAlertController: UIViewController {
    
    var event : Event!
    var index : Int!
    var delegate : DeleteEventDelegate?
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteEvent(index: index, event: event)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyFormatting()
        
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
        deleteButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = Settings.shared.accentColor
        cancelButton.setTitleColor(Settings.shared.backgroundColor, for: .normal)
        deleteButton.backgroundColor = Settings.shared.backgroundColor
        deleteButton.setTitleColor(Settings.shared.accentColor, for: .normal)
    }

}

protocol DeleteEventDelegate {
    func deleteEvent(index: Int, event: Event)
}
