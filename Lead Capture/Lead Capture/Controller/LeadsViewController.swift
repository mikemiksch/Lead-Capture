////
////  LeadsViewController.swift
////  Lead Capture
////
////  Created by Mike Miksch on 11/15/17.
////  Copyright © 2017 Mike MIksch. All rights reserved.
////
//
//import UIKit
//
//class LeadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddLeadDelegate {
//
//    var selectedEvent : Event!
//
//    @IBOutlet weak var leadsTable: UITableView!
//    @IBOutlet weak var titleBar: UINavigationItem!
//
//    @IBAction func addButtonPressed(_ sender: Any) {
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        leadsTable.dataSource = self
//        leadsTable.delegate = self
//        titleBar.title = selectedEvent.name
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        leadsTable.reloadData()
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if let destinationViewController = segue.destination as? AddLeadViewController {
//            destinationViewController.delegate = self
//        }
//        if let destinationViewController = segue.destination as? LeadDetailViewController {
//            let selectedIndex = leadsTable.indexPathForSelectedRow!.row
//            let selectedLead = selectedEvent.leads[selectedIndex]
//            destinationViewController.currentLead = selectedLead
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return selectedEvent.leads.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        let lead = self.selectedEvent.leads[indexPath.row]
//        if lead.name != "" {
//            cell.textLabel!.text = lead.name
//        } else {
//            cell.textLabel!.text = "No name given"
//        }
//
//        if lead.date != "" {
//            cell.detailTextLabel!.text = lead.date
//        } else {
//            cell.detailTextLabel!.text = "No date given"
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "LeadDetailViewController", sender: nil)
//        leadsTable.deselectRow(at: indexPath, animated: true)
//    }
//
//    func addLead(lead: Lead) {
//        self.selectedEvent.leads.append(lead)
//    }
//
//}

