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
        
        let eventListView = EventListView(eventList: self.eventList, controller: self)
        
        let hostingView = NSHostingView(rootView: eventListView )
        
        contentView.addSubview(hostingView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 600).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500).isActive = true
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        hostingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func fetchEvents() {
        
        let fetchRequest: NSFetchRequest<EventEntity>
        
        fetchRequest = EventEntity.fetchRequest()
        
        do {
            
            let eventsEntities = try managedContext.fetch(fetchRequest)
            
//             print("Event Entity count: \(eventsEntities.count)")
            
            let events = convertEvents(eventEntities: eventsEntities)
            
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
    
    func addEvent(event: Event) {
        
        addEventEntity(event: event)
    }
    
    func addEventEntity(event: Event) {
        
        
        let eventEntity = EventEntity(context: self.managedContext)
        
        eventEntity.name = event.name
        eventEntity.date = event.date
        eventEntity.id = event.id
        
        do {
            
           try managedContext.save()
            
            self.eventList.objectWillChange.send()
            
            fetchEvents()
           
        } catch let error as NSError {
            
            print("Error adding event: \(error)")
        }
    }
    
    
    fileprivate func deleteEventEntity(id: UUID)
    {
        let fetchRequest: NSFetchRequest<EventEntity>
        
        fetchRequest = EventEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            
            let fetchedResults = try self.managedContext.fetch(fetchRequest)
            
            print(fetchedResults.count)
            
            if let eventEntity = fetchedResults.first {
                
                print("\(String(describing: eventEntity.id))")
                self.managedContext.delete(eventEntity)
                
            }
            
        } catch let error as NSError {
            print("Error fetching event: \(error)")
        }
    }
    
    func deleteEvent(id: UUID) {
        
        deleteEventEntity(id: id)
        
        fetchEvents()
    }
    
    func updateEvent(event: Event) {
        
        updateEventEntity(event: event)
        
        fetchEvents()
        
    }
    
    func updateEventEntity(event: Event) {
        
        let fetchRequest: NSFetchRequest<EventEntity>
        
        fetchRequest = EventEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", event.id.uuidString)
        
        do {
            
            let fetchedResults = try self.managedContext.fetch(fetchRequest)
            
            print(fetchedResults.count)
            
            if let eventEntity = fetchedResults.first {
                
                print("\(String(describing: eventEntity.id))")
                
                eventEntity.name = event.name
                eventEntity.date = event.date
                try self.managedContext.save()
                
                
            }
            
        } catch let error as NSError {
            print("Error fetching event: \(error)")
        }
        
        
        
    }
    
    
}

