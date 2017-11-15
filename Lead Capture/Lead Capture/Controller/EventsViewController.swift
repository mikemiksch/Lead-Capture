//
//  EventsViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTable: UITableView!

    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    
    var events = [Event]() {
        didSet {
            eventsTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.dataSource = self
        eventsTable.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}
