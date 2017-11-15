//
//  LeadsViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class LeadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedEvent : Event!
    var leads = [Lead]() {
        didSet {
            leadsTable.reloadData()
        }
    }

    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var titleBar: UINavigationItem!
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadsTable.dataSource = self
        leadsTable.delegate = self
        titleBar.title = selectedEvent.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
