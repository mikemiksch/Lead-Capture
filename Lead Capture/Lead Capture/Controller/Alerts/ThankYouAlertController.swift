//
//  ThankYouAlertController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/8/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class ThankYouAlertController: UIViewController {
    
    var message : String?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewBox: UIView!
    @IBAction func tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message ?? "Thank You!"
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
    }
}
