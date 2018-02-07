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
    var isSortMenuHidden = true
    
    var leads = [Lead]() {
        didSet {
            leadsTable.reloadData()
        }
    }

    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortMenuView: UIView!
    @IBOutlet weak var sortMenuViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortMenuViewWidthConstraint: NSLayoutConstraint!
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        handleSortMenu()
    }
    
    @IBAction func flagStatusButtonPressed(_ sender: Any) {
        sortByFlag()
        selectedEvent.sortKey = "byFlag"
        PersistenceService.saveContext()
        handleSortMenu()
    }
    
    @IBAction func collectionOrderButtonPressed(_ sender: Any) {
        sortByCollection()
        selectedEvent.sortKey = "byCollection"
        PersistenceService.saveContext()
        handleSortMenu()
    }
    
    @IBAction func contactNameButtonPressed(_ sender: Any) {
        sortByName()
        selectedEvent.sortKey = "byName"
        PersistenceService.saveContext()
        handleSortMenu()
    }
    
    @IBAction func weddingDateButtonPressed(_ sender: Any) {
        sortByDate()
        selectedEvent.sortKey = "byDate"
        PersistenceService.saveContext()
        handleSortMenu()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if !isSortMenuHidden {
            handleSortMenu()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addEventAlert = storyboard.instantiateViewController(withIdentifier: "AddEventAlert") as! AddEventAlertController
        addEventAlert.currentEvent = selectedEvent
        addEventAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addEventAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(addEventAlert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        titleBar.title = selectedEvent.name
        leads = (selectedEvent.leads?.allObjects as! [Lead])
        if let sortKey = selectedEvent.sortKey {
            switch sortKey {
            case "byFlag":
                sortByFlag()
            case "byCollection":
                sortByCollection()
            case "byName":
                sortByName()
            case "byDate":
                sortByDate()
            default:
                sortByFlag()
            }
        } else {
            sortByFlag()
        }
        applyFormatting()
//        animateLeadCells()
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
            destinationViewController.currentEvent = self.selectedEvent
        }
        if !isSortMenuHidden {
            handleSortMenu()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noLeadsLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        noLeadsLabel.text = "You have no leads saved for this event"
        noLeadsLabel.textAlignment = .center
        noLeadsLabel.font = UIFont(name: "Existence-UnicaseLight", size: 17.0)
        noLeadsLabel.textColor = UIColor.gray
        self.leadsTable.backgroundView = noLeadsLabel
        if leads.count == 0 {
            noLeadsLabel.isHidden = false
            return 0
        } else {
            noLeadsLabel.isHidden = true
            return leads.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leadsTable.dequeueReusableCell(withIdentifier: "LeadCell", for: indexPath) as! LeadCell
        let lead = self.leads[indexPath.row]
        
        if lead.name != "" {
            if lead.partner != "" {
                cell.nameField.text = "\(lead.name!) & \(lead.partner!)"
            } else {
                cell.nameField.text = lead.name
            }
        } else {
            if lead.partner != "" {
                cell.nameField.text = lead.partner!
            } else {
                cell.nameField.text = "No Name Given"
            }
        }
        cell.nameField.adjustsFontSizeToFitWidth = true
        
        if lead.date != "" {
            cell.dateField.text = lead.date
        } else {
            cell.dateField.text = "No Date Given"
        }

        if lead.flagged {
            cell.icon.image = #imageLiteral(resourceName: "flaggedlead")
        } else {
            cell.icon.image = #imageLiteral(resourceName: "leadIcon")
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if !isSortMenuHidden {
            handleSortMenu()
        }
        let selectedLead = self.leads[indexPath.row]
        
        let flag = UITableViewRowAction(style: .normal, title: "Flag") { (action, indexPath) in
            selectedLead.flagged = !selectedLead.flagged
            PersistenceService.saveContext()
            let cell = tableView.cellForRow(at: indexPath) as! LeadCell
            if selectedLead.flagged {
                cell.icon.image = #imageLiteral(resourceName: "flaggedlead")
            } else {
                cell.icon.image = #imageLiteral(resourceName: "leadIcon")
            }
            return
        }
        flag.backgroundColor = UIColor.orange
        
        if selectedLead.flagged == true {
            flag.title = "Unflag"
            flag.backgroundColor = UIColor.darkGray
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let deleteAlert = storyboard.instantiateViewController(withIdentifier: "DeleteLeadAlert") as! DeleteLeadAlertController
            deleteAlert.delegate = self
            deleteAlert.lead = selectedLead
            deleteAlert.index = indexPath.row
            deleteAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            deleteAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(deleteAlert, animated: true, completion: nil)
            return
        }
        
        return [delete, flag]
    }
    
    func sortByFlag() {
        leads = leads.sorted(by: { (first, second) -> Bool in
            if first.flagged == second.flagged {
                return second.createdOn! as Date > first.createdOn! as Date
            }
            return first.flagged && !second.flagged
        })
    }
    
    func sortByCollection() {
        leads = leads.sorted(by: { (first, second) -> Bool in
            return second.createdOn! as Date > first.createdOn! as Date
        })
    }
    
    func sortByName() {
        leads = leads.sorted(by: { (first, second) -> Bool in
            if (first.name == "No Name Given" || first.name == "") || (second.name == "No Name Give" || second.name == "") {
                return first.name! > second.name!
            } else {
                return second.name! > first.name!
            }
        })
    }
    
    func sortByDate() {
        leads = leads.sorted(by: { (first, second) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            if first.date == "No Date Given" || second.date == "No Date Given"  {
                return second.date! > first.date!
            } else if first.date == "" || second.date == "" {
                return first.date! > second.date!
            } else {
                return dateFormatter.date(from: second.date!)! > dateFormatter.date(from: first.date!)!
            }
        })
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
    
    func handleCheckmark(_: UIButton) {
        
    }
    
    func handleSortMenu() {
        if isSortMenuHidden {
            sortMenuViewTrailingConstraint.constant = 0
            sortButton.setTitle("Close", for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            sortMenuViewTrailingConstraint.constant = sortMenuViewWidthConstraint.constant
            sortButton.setTitle("Sort Leads By", for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isSortMenuHidden = !isSortMenuHidden
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
        sortMenuViewTrailingConstraint.constant = sortMenuViewWidthConstraint.constant + 5
        
        sortMenuView.layer.shadowColor = UIColor.black.cgColor
        sortMenuView.layer.shadowOpacity = 0.5
        sortMenuView.layer.shadowOffset = CGSize.zero
        sortMenuView.layer.shadowPath = UIBezierPath(rect: sortMenuView.bounds).cgPath    }
    
    func deleteLead(index: Int, lead: Lead) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lead")
        request.predicate = NSPredicate(format: "leadID == %@", lead.leadID!)
        
        do {
            let result = try PersistenceService.context.fetch(request)
            for object in result {
                PersistenceService.context.delete(object as! NSManagedObject)
            }
            PersistenceService.saveContext()
            leads.remove(at: index)
        } catch {
            print(error)
        }
    }

    func addLead(lead: Lead) {
        leads.append(lead)
        selectedEvent.leads?.adding(lead)
        PersistenceService.saveContext()
    }

}

