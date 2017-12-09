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
    
    @IBOutlet weak var eventsTable: UITableView!

    @IBAction func addButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addEventAlert = storyboard.instantiateViewController(withIdentifier: "AddEventAlert") as! AddEventAlertController
        addEventAlert.delegate = self
        addEventAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addEventAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(addEventAlert, animated: true, completion: nil)
//        let addAlertController = UIAlertController(title: "Add New Event", message: "Enter a name for a new event", preferredStyle: .alert)
//        addAlertController.addTextField(configurationHandler: nil)
//        let confirm = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            if let eventName = addAlertController.textFields?[0].text {
//                let newEvent = Event(context: PersistenceService.context)
//                if eventName == "" {
//                    newEvent.name = "Unnamed Event"
//                } else {
//                    newEvent.name = eventName
//                }
//                newEvent.createdOn = NSDate()
//                newEvent.eventID = UUID().uuidString
//                PersistenceService.saveContext()
//                self.events.append(newEvent)
//            }
//        })
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        addAlertController.addAction(confirm)
//        addAlertController.addAction(cancel)
//        present(addAlertController, animated: true, completion: nil)
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
        fetchAllLeadds()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let event = self.events[indexPath.row]
        if let eventName = event.name {
            cell.textLabel!.text = String(describing: eventName)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let deleteAlert = storyboard.instantiateViewController(withIdentifier: "DeleteEventAlert") as! DeleteEventAlertController
            deleteAlert.delegate = self
            deleteAlert.event = self.events[indexPath.row]
            deleteAlert.index = indexPath.row
            deleteAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            deleteAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(deleteAlert, animated: true, completion: nil)
        }
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
        
        if date != "" {
            newEvent.date = date
        }
        newEvent.createdOn = NSDate()
        newEvent.eventID = UUID().uuidString
        PersistenceService.saveContext()
        self.events.append(newEvent)
    }
    
    // MARK: - fetchAllLeads function
    
    func fetchAllLeadds() {
        let fetchRequest : NSFetchRequest<Lead> = Lead.fetchRequest()
        
        do {
            let leads = try PersistenceService.context.fetch(fetchRequest)
            print("Leads count")
            print(leads.count)
        } catch {
            print("Error fetching all leads")
        }
    }

}
