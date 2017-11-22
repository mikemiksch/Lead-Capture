//
//  UIToolbar + doneButton.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/21/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

extension UIToolbar {

    func ToolbarButtons(selection : Selector) -> UIToolbar {
        let toolBar = UIToolbar()
    
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
    
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: selection)
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar

    }
}
