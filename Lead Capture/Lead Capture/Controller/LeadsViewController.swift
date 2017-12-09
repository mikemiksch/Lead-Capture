//
//  LeadsViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit
import CoreData

class LeadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddLeadDelegate, DeleteLeadDelegate {

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
        self.leads = (selectedEvent.leads?.allObjects as! [Lead]).sorted(by: { (first, second) -> Bool in
            second.createdOn! as Date > first.createdOn! as Date
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        leadsTable.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationViewController = segue.destination as? AddLeadViewController {
            destinationViewController.delegate = self
            destinationViewController.currentEvent = self.selectedEvent
        }
        if let destinationViewController = segue.destination as? LeadDetailViewController {
            let selectedIndex = leadsTable.indexPathForSelectedRow!.row
            let selectedLead = self.leads[selectedIndex]
            destinationViewController.currentLead = selectedLead
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leads.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let lead = self.leads[indexPath.row]
        if lead.name != "" {
            cell.textLabel!.text = lead.name
        } else {
            cell.textLabel!.text = "No name given"
        }

        if lead.date != "" {
            cell.detailTextLabel!.text = lead.date
        } else {
            cell.detailTextLabel!.text = "No date given"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "LeadDetailViewController", sender: nil)
        leadsTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let deleteAlert = storyboard.instantiateViewController(withIdentifier: "DeleteLeadAlert") as! DeleteLeadAlertController
            deleteAlert.delegate = self
            deleteAlert.lead = self.leads[indexPath.row]
            deleteAlert.index = indexPath.row
            deleteAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            deleteAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(deleteAlert, animated: true, completion: nil)
        
//            let deleteAlert = UIAlertController(title: "Delete Lead?", message: "Are you sure you want to delete this lead?", preferredStyle: .alert)
//            let confirmDelete = UIAlertAction(title: "Delete Lead", style: .destructive, handler: { (_ UIAlertAction) in
//                if let deleteLeadID = self.leads[indexPath.row].leadID {
//                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lead")
//                    request.predicate = NSPredicate(format: "leadID == %@", deleteLeadID)
//
//                    do {
//                        let result = try PersistenceService.context.fetch(request)
//                        for object in result {
//                            PersistenceService.context.delete(object as! NSManagedObject)
//                        }
//                        PersistenceService.saveContext()
//                        self.leads.remove(at: indexPath.row)
//                    } catch {
//                        print(error)
//                    }
//                }
//            })
//            let cancelDelete = UIAlertAction(title: "Keep Lead", style: .cancel, handler: nil)
//            deleteAlert.addAction(confirmDelete)
//            deleteAlert.addAction(cancelDelete)
//            present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    func deleteLead(index: Int, lead: Lead) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lead")
        request.predicate = NSPredicate(format: "leadID == %@", lead.leadID!)
        
        do {
            let result = try PersistenceService.context.fetch(request)
            for object in result {
                PersistenceService.context.delete(object as! NSManagedObject)
            }
            PersistenceService.saveContext()
            self.leads.remove(at: index)
        } catch {
            print(error)
        }
    }

    func addLead(lead: Lead) {
        self.leads.append(lead)
        self.selectedEvent.leads?.adding(lead)
        PersistenceService.saveContext()
    }

}

