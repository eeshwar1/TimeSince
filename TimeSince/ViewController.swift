//
//  ViewController.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/24/22.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var contentView: NSView!
    
    @Published var eventList: EventList = EventList()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.managedContext = appDelegate.persistentContainer.viewContext
        
        fetchEvents()
        
        setupSubviews()
        
        
        
        
    }
    
    fileprivate func setupSubviews() {
        
        let eventListView = NSHostingView(rootView: EventListView(eventList: self.eventList))
        
        contentView.addSubview(eventListView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 480).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500).isActive = true
        eventListView.translatesAutoresizingMaskIntoConstraints = false
        eventListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        eventListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        eventListView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        eventListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func fetchEvents() {
        
        let fetchRequest: NSFetchRequest<EventEntity>
        
        fetchRequest = EventEntity.fetchRequest()
        
        do {
            
            let eventsEntities = try managedContext.fetch(fetchRequest)
            
            print("Event Entity count: \(eventsEntities.count)")
            
            let events = convertEvents(eventEntities: eventsEntities)
            
            print("Event count: \(events.count)")
            
            //            for event in events {
            //
            //                print("\(String(describing: event.id))")
            //            }
            self.eventList.objectWillChange.send()
            self.eventList.setEvents(events: events)
            
            
        } catch let error as NSError {
            print("Error fetching events: \(error)")
        }
    }
    
    func convertEvents(eventEntities: [EventEntity]) -> [Event] {
        
        var events: [Event] = []
        for eventEntity in eventEntities {
            
            let event = Event(name: eventEntity.name ?? "None", date: eventEntity.date!.stringFromDateShort(), id: eventEntity.id ?? UUID())
            
            events.append(event)
        }
        
        return events
    }
    
    
    
    func addEventEntity(context: NSManagedObjectContext) {
        
        
        let eventEntity = EventEntity(context: context)
        
        eventEntity.id = UUID()
        eventEntity.name = "New Event at \(Date())"
        eventEntity.date = Date()
        
        
        do {
            
            
            try context.save()
            
            self.eventList.objectWillChange.send()
            
            fetchEvents()
            
            
            
        } catch let error as NSError {
            
            print("Error adding event: \(error)")
        }
    }
    
    func deleteEventEntity(eventEntity: EventEntity, context: NSManagedObjectContext)
    {
        
        context.delete(eventEntity)
        
        do {
            try context.save()
        } catch let error as NSError {
            
            print("Error deleting event: \(error)")
        }
        
    }
    
    @IBAction func addEvent(sender: NSButton) {
        
        addEventEntity(context: self.managedContext)
    }
    
    //    @IBAction func deleteEvent(sender: NSButton) {
    //
    //        print("Delete event")
    //
    //        let fetchRequest: NSFetchRequest<EventEntity>
    //
    //        fetchRequest = EventEntity.fetchRequest()
    //
    //        fetchRequest.predicate = NSPredicate(format: "id = %@", "1712E90D-598B-48ED-ADB3-8AA1C00671FA")
    //
    //        do {
    //
    //            let fetchedResults = try self.managedContext.fetch(fetchRequest)
    //
    //            print(fetchedResults.count)
    //
    //            if let eventEntity = fetchedResults.first {
    //
    //                print("\(String(describing: eventEntity.id))")
    //                self.managedContext.delete(eventEntity)
    //
    //            }
    //
    //        } catch let error as NSError {
    //            print("Error fetching event: \(error)")
    //        }
    //    }
}

