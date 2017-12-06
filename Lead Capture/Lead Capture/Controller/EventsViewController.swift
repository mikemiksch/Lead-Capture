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
        self.performSegue(withIdentifier: "LeadsViewController", sender: nil)
        eventsTable.deselectRow(at: indexPath, animated: true)
    }
    

}
