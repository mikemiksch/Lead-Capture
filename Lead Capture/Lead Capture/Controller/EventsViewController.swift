//
//  EventsViewController.swift
//  Lead Capture
//
//  Created by Mike Miksch on 11/15/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit
import CoreData

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTable: UITableView!

    @IBAction func addButtonPressed(_ sender: Any) {
        let addAlertController = UIAlertController(title: "Add New Event", message: "Enter a name for a new event", preferredStyle: .alert)
        addAlertController.addTextField(configurationHandler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let eventName = addAlertController.textFields?[0].text {
                let newEvent = Event(context: PersistenceService.context)
                if eventName == "" {
                    newEvent.name = "Unnamed Event"
                } else {
                    newEvent.name = eventName
                }
                newEvent.createdOn = NSDate()
                newEvent.eventID = UUID().uuidString
                PersistenceService.saveContext()
                self.events.append(newEvent)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlertController.addAction(confirm)
        addAlertController.addAction(cancel)
        present(addAlertController, animated: true, completion: nil)
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
            self.events = events
        } catch {
            print("Error fetching events from managed object context")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        if segue.identifier == "LeadsViewController" {
//            let selectedIndex = eventsTable.indexPathForSelectedRow!.row
//            let selectedEvent = self.events[selectedIndex]
//
//            if let destinationViewController = segue.destination as? LeadsViewController {
//                destinationViewController.selectedEvent = selectedEvent
//            }
//        }
//    }

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
//        self.performSegue(withIdentifier: "LeadsViewController", sender: nil)
        eventsTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let deleteAlert = UIAlertController(title: "Delete Event?", message: "Are you sure you want to delete this event and all leads?", preferredStyle: .alert)
            let confirmDelete = UIAlertAction(title: "Delete Event", style: .destructive, handler: { (_ action: UIAlertAction) in
                if let deleteEventID = self.events[indexPath.row].eventID {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
                    request.predicate = NSPredicate(format: "eventID == %@", deleteEventID)
                    
                    do {
                        let result = try PersistenceService.context.fetch(request)
                        for object in result {
                            PersistenceService.context.delete(object as! NSManagedObject)
                        }
                        PersistenceService.saveContext()
                        self.events.remove(at: indexPath.row)
                    } catch {
                        print(error)
                    }
                }
            })
            let cancelDelete = UIAlertAction(title: "Keep Event", style: .cancel, handler: nil)
            deleteAlert.addAction(confirmDelete)
            deleteAlert.addAction(cancelDelete)
            present(deleteAlert, animated: true, completion: nil)
        }
    }

}
