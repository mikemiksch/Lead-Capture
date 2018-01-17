//
//  SplashFadeViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 12/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class SplashFadeViewController: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0, delay: 2.0, options: .curveEaseOut, animations: {
            self.splashImage.alpha = 0
        }, completion: nil)
        let eventsView = EventsViewController()
        self.present(eventsView, animated: true, completion: nil)
    }

}
