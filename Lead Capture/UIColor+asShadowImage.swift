//
//  UIColor+asShadowImage.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/9/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

extension UIColor {
    func asShadowImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
