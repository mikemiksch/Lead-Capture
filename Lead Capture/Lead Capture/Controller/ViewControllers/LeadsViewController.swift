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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        titleBar.title = selectedEvent.name
        self.leads = (selectedEvent.leads?.allObjects as! [Lead]).sorted(by: { (first, second) -> Bool in
            second.createdOn! as Date > first.createdOn! as Date
        })
        applyFormatting()
        animateLeadCells()
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
        let cell = leadsTable.dequeueReusableCell(withIdentifier: "LeadCell", for: indexPath) as! LeadCell
        let lead = self.leads[indexPath.row]
        if lead.partner != "" {
            cell.nameField.text = "\(lead.name!) & \(String(describing: lead.partner))"
        } else {
            cell.nameField.text = lead.name
        }
        cell.dateField.text = lead.date
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
        }
    }
    
    func tableSetup() {
        leadsTable.dataSource = self
        leadsTable.delegate = self
        leadsTable.separatorColor = Settings.shared.accentColor
        leadsTable.backgroundColor = UIColor.clear
        leadsTable.tableFooterView = UIView(frame: CGRect.zero)
        leadsTable.estimatedRowHeight = UITableViewAutomaticDimension
        leadsTable.rowHeight = UITableViewAutomaticDimension
        leadsTable.layer.cornerRadius = 10
        
        
        let eventNib = UINib(nibName: "LeadCell", bundle: nil)
        leadsTable.register(eventNib, forCellReuseIdentifier: LeadCell.identifier)
    }
    
    func animateLeadCells() {
        if leads.count >= 1 {
            leadsTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            let visibleCells = leadsTable.visibleCells.map { (cell) -> LeadCell in
                cell.transform = CGAffineTransform(translationX: 0, y: leadsTable.bounds.size.height)
                
                return cell as! LeadCell
            }
            
            var index = 0
            
            for cell in visibleCells {
                UIView.animate(withDuration: 0.50, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    cell.transform =  CGAffineTransform.identity
                })
                index += 1
            }
        }
    }
    
    func applyFormatting() {
        self.view.backgroundColor = Settings.shared.backgroundColor
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

