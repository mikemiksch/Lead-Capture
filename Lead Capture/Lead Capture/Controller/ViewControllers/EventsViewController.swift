//
//  EventsViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit
import CoreData

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DeleteEventDelegate, AddEventDelegate {
    
    var events = [Event]() {
        didSet {
            eventsTable.reloadData()
        }
    }
    
    var animateFlag = false
    var isSortMenuHidden = true
    
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var creationOrderButton: UIButton!
    @IBOutlet weak var eventNameButton: UIButton!
    @IBOutlet weak var eventDateButton: UIButton!
    @IBOutlet weak var sortMenuView: UIView!
    @IBOutlet weak var numberofLeadsButton: UIButton!
    @IBOutlet weak var sortMenuViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortMenuViewWidthConstraint: NSLayoutConstraint!
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        handleSortMenu()
    }
    
    @IBAction func nameButtonPressed(_ sender: Any) {
        sortByName()
        userDefaults.set("byName", forKey: "Event Sort Key")
        handleSortMenu()
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        sortByDates()
        userDefaults.set("byDate", forKey: "Event Sort Key")
        handleSortMenu()
    }
    
    @IBAction func leadsButtonPressed(_ sender: Any) {
        sortByLeads()
        userDefaults.set("byLeads", forKey: "Event Sort Key")
        handleSortMenu()
    }
    
    @IBAction func creationOrderButtonPressed(_ sender: Any) {
        print("Creation order pressed")
        sortByCreation()
        userDefaults.set("byCreation", forKey: "Event Sort Key")
        handleSortMenu()
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if !isSortMenuHidden {
            handleSortMenu()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addEventAlert = storyboard.instantiateViewController(withIdentifier: "AddEventAlert") as! AddEventAlertController
        addEventAlert.delegate = self
        addEventAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addEventAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(addEventAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        applyFormatting()
        let fetchRequest : NSFetchRequest<Event> = Event.fetchRequest()
        do {
            self.events = try PersistenceService.context.fetch(fetchRequest)
        } catch {
            print("Error fetching events from managed object context")
        }
        if let defaultsKey = userDefaults.object(forKey: "Event Sort Key") {
            let sortKey = defaultsKey as! String
            
            switch sortKey {
            case "byCreation":
                sortByCreation()
            case "byLeads":
                sortByLeads()
            case "byDate":
                sortByDates()
            case "byName":
                sortByName()
            default:
                sortByCreation()
            }
        } else {
            sortByCreation()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        eventsTable.reloadData()
//        animateEventCells()
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "LeadsViewController" {
            let selectedIndex = eventsTable.indexPathForSelectedRow!.row
            let selectedEvent = self.events[selectedIndex]
            if let destinationViewController = segue.destination as? LeadsViewController {
                destinationViewController.selectedEvent = selectedEvent
            }
        }
        
        if !isSortMenuHidden {
            handleSortMenu()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if !isSortMenuHidden {
            handleSortMenu()
        }
        
        let selectedEvent = self.events[indexPath.row]
        
        let flag = UITableViewRowAction(style: .normal, title: "Flag") { (action, indexPath) in
            selectedEvent.flagged = !selectedEvent.flagged
            PersistenceService.saveContext()
            let cell = tableView.cellForRow(at: indexPath) as! EventCell
            if selectedEvent.flagged {
                cell.icon.image = #imageLiteral(resourceName: "flaggedevent")
            } else {
                cell.icon.image = #imageLiteral(resourceName: "eventIcon")
            }
            return
        }
        
        flag.backgroundColor = UIColor.orange
        
        if selectedEvent.flagged == true {
            flag.title = "Unflag"
            flag.backgroundColor = UIColor.darkGray
        }
        
        let export = UITableViewRowAction(style: .normal, title: "Export\nCSV") { (action, indexPath) in
            let selectedEvent = self.events[indexPath.row]
            self.createCSV(event: selectedEvent)
            return
        }
        export.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let deleteAlert = storyboard.instantiateViewController(withIdentifier: "DeleteEventAlert") as! DeleteEventAlertController
            deleteAlert.delegate = self
            deleteAlert.event = self.events[indexPath.row]
            deleteAlert.index = indexPath.row
            deleteAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            deleteAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(deleteAlert, animated: true, completion: nil)
            return
        }
        
        return [delete, export, flag]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noEventLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        noEventLabel.text = "You have no events saved"
        noEventLabel.textAlignment = .center
        noEventLabel.font = UIFont(name: "Existence-UnicaseLight", size: 17.0)
        noEventLabel.textColor = UIColor.gray
        self.eventsTable.backgroundView = noEventLabel
        if events.count == 0 {
            noEventLabel.isHidden = false
            return 0
        } else {
            noEventLabel.isHidden = true
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTable.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = self.events[indexPath.row]
        cell.dateField.text = event.date
        cell.eventNameField.text = event.name
        cell.eventNameField.adjustsFontSizeToFitWidth = true
        if event.leads!.count == 1 {
            cell.leadCountField.text = "\(event.leads!.count) Lead"
        } else {
            cell.leadCountField.text = "\(event.leads!.count) Leads"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "LeadsViewController", sender: nil)
        eventsTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func sortByName() {
        events = events.sorted(by: { (first, second) -> Bool in
            return second.name! > first.name!
        })
    }
    
    func sortByDates() {
        events = events.sorted(by: { (first, second) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            if first.date == "" || second.date == "" {
                return first.date! > second.date!
            }
            return dateFormatter.date(from: second.date!)! > dateFormatter.date(from: first.date!)!
        })
    }
    
    func sortByLeads() {
        events = events.sorted(by: { (first, second) -> Bool in
            return first.leads!.count > second.leads!.count
        })
    }
    
    func sortByCreation() {
        print("Sorting by creation")
        events = events.sorted(by: { (first, second) -> Bool in
            return second.createdOn! as Date > first.createdOn! as Date
        })
    }
    
    func tableSetup() {
        eventsTable.dataSource = self
        eventsTable.delegate = self
        eventsTable.separatorColor = Settings.shared.accentColor
        eventsTable.backgroundColor = UIColor.clear
        eventsTable.tableFooterView = UIView(frame: CGRect.zero)
        eventsTable.estimatedRowHeight = UITableViewAutomaticDimension
        eventsTable.rowHeight = UITableViewAutomaticDimension
        eventsTable.layer.cornerRadius = 10
        
        
        let eventNib = UINib(nibName: "EventCell", bundle: nil)
        eventsTable.register(eventNib, forCellReuseIdentifier: EventCell.identifier)
    }
    
    func applyFormatting() {
        sortMenuViewTrailingConstraint.constant = sortMenuViewWidthConstraint.constant + 5
        
        sortMenuView.layer.shadowColor = UIColor.black.cgColor
        sortMenuView.layer.shadowOpacity = 0.5
        sortMenuView.layer.shadowOffset = CGSize.zero
        sortMenuView.layer.shadowPath = UIBezierPath(rect: sortMenuView.bounds).cgPath
    }
    
    func handleSortMenu() {
        print("Handling sort menu")
        if isSortMenuHidden {
            print("Show sort menu")
            sortMenuViewTrailingConstraint.constant = 0
            sortButton.setTitle("Close", for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            print("Hide sort menu")
            sortMenuViewTrailingConstraint.constant = sortMenuViewWidthConstraint.constant + 5
            sortButton.setTitle("Sort Events By", for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isSortMenuHidden = !isSortMenuHidden
        print(isSortMenuHidden)
    }
    
    func createCSV(event: Event) {
        let fileName = "\(String(describing: event.name!)) Leads.csv"
        let tempDirectory = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        var csvText = "Flagged,Name,Partner,Date,Location,Phone Number,Email,OK to Contact,Comments\n"
        
        guard let leads = event.leads?
            .sorted(by: { (first, second) -> Bool in
            let firstLead = first as! Lead
            let secondLead = second as! Lead
            if let sortKey = event.sortKey {
                switch sortKey {
                case "byFlag":
                    if firstLead.flagged == secondLead.flagged {
                        return secondLead.createdOn! as Date > firstLead.createdOn! as Date
                    }
                    return firstLead.flagged && !secondLead.flagged
                case "byCollection":
                    return secondLead.createdOn! as Date > firstLead.createdOn!as Date
                case "byName":
                    return secondLead.name! > firstLead.name!
                case "byDate":
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .none
                    if (firstLead.date == "No Date Given" || firstLead.date == "") || (secondLead.date == "No Date Given" || secondLead.date == "") {
                        return secondLead.date! > firstLead.date!
                    } else {
                        return dateFormatter.date(from: secondLead.date!)! > dateFormatter.date(from: firstLead.date!)!
                    }
                default:
                    if firstLead.flagged == secondLead.flagged {
                        return secondLead.createdOn! as Date > firstLead.createdOn! as Date
                    }
                    return firstLead.flagged && !secondLead.flagged
                }
            } else {
                if firstLead.flagged == secondLead.flagged {
                    return secondLead.createdOn! as Date > firstLead.createdOn! as Date
                }
                return firstLead.flagged && !secondLead.flagged
            }
        })
            else { return }
        for each in leads {
            let lead = each as! Lead
            let newLine = "\(lead.flagged),\(lead.name!),\(lead.partner!),\(lead.date!),\(lead.location!),\(lead.phoneNum!),\(lead.email!),\(lead.subscribe),\(lead.comments!)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create CSV file: \(error)")
        }
        
        let activityView = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        activityView.title = "Export CSV File"
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityView.popoverPresentationController?.sourceView = self.view
            activityView.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            activityView.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        present(activityView, animated: true, completion: nil)
    }
    
    func animateEventCells() {
        if animateFlag == false && events.count >= 1 {
            eventsTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            let visibleCells = eventsTable.visibleCells.map { (cell) -> EventCell in
                cell.transform = CGAffineTransform(translationX: 0, y: eventsTable.bounds.size.height)

                return cell as! EventCell
            }
        
            var index = 0
        
            for cell in visibleCells {
                UIView.animate(withDuration: 0.50, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform =  CGAffineTransform.identity
                })
                index += 1
            }
        
        }
        animateFlag = true
    }
    
    func deleteEvent(index: Int, event: Event) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        request.predicate = NSPredicate(format: "eventID == %@", event.eventID!)
        
        do {
            let result = try PersistenceService.context.fetch(request)
            for object in result {
                PersistenceService.context.delete(object as! NSManagedObject)
            }
            PersistenceService.saveContext()
            self.events.remove(at: index)
        } catch {
            print(error)
        }
    }
    
    func addEvent(name: String, date: String) {
        let newEvent = Event(context: PersistenceService.context)
        if name == "" {
            newEvent.name = "Unnamed Event"
        } else {
            newEvent.name = name
        }
        newEvent.date = date
        newEvent.createdOn = NSDate()
        newEvent.eventID = UUID().uuidString
        PersistenceService.saveContext()
        self.events.append(newEvent)
    }

}
