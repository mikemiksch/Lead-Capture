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
    
    @IBOutlet weak var eventsTable: UITableView!

    @IBAction func addButtonPressed(_ sender: Any) {
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
        
        let fetchRequest : NSFetchRequest<Event> = Event.fetchRequest()
        do {
            let events = try PersistenceService.context.fetch(fetchRequest)
            self.events = events.sorted(by: { (first, second) -> Bool in
                second.createdOn! as Date > first.createdOn! as Date
            })
        } catch {
            print("Error fetching events from managed object context")
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
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let export = UITableViewRowAction(style: .normal, title: "Export CSV") { (action, indexPath) in
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
        
        return [delete, export]
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.delete {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let deleteAlert = storyboard.instantiateViewController(withIdentifier: "DeleteEventAlert") as! DeleteEventAlertController
//            deleteAlert.delegate = self
//            deleteAlert.event = self.events[indexPath.row]
//            deleteAlert.index = indexPath.row
//            deleteAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            deleteAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            present(deleteAlert, animated: true, completion: nil)
//        }
//    }
    
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
    
    func createCSV(event: Event) {
        let fileName = "\(String(describing: event.name!)) Leads.csv"
        let tempDirectory = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        var csvText = "Name,Partner,Date,Location,Phone Number,Email,OK to Contact,Comments\n"
        
        guard let leads = event.leads else { return }
        for each in leads {
            let lead = each as! Lead
            let newLine = "\(lead.name!),\(lead.partner!),\(lead.date!),\(lead.location!),\(lead.phoneNum!),\(lead.email!),\(lead.subscribe),\(lead.comments!)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print(csvText)
        } catch {
            print("Failed to create CSV file: \(error)")
        }
        
        let activityView = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
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
