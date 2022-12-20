//
//  EventList.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/23/22.
//

import Foundation

class EventList: ObservableObject {
    
    private var events: [Event]
    
    private var sortedBy: String = "Date"
    private var ascendingOrder: Bool = false
    
    init() {
        
        self.events = []
    }
    init(events: [Event]) {
        
        self.events = events
    }
    
    func setEvents(events: [Event]) {
        
        self.events = events
        self.sortEvents()
    }
    
    func getEvents() -> [Event] {
        
        return self.events
        
    }
    
    func getSortOrder() -> (sortedBy: String, ascendingOrder: Bool) {
        
        return (sortedBy: self.sortedBy, ascendingOrder: self.ascendingOrder)
    }
    func setSortOrder(field: String, ascendingOrder: Bool) {
        
        if (field.lowercased() == "name" ||
            field.lowercased() == "date") {
            
            self.sortedBy = field
            
        } else {
            
            print("setSortOrder: ERROR Invalid sorted field \(field)")
        }
        
        self.ascendingOrder = ascendingOrder
        
        sortEvents()
    }
    
    func sortEvents() {
      
        var sortedEvents: [Event] = []
        
        if (sortedBy.lowercased() == "name") {
            
            if (ascendingOrder == true) {
                sortedEvents = events.sorted(by: { $0.name < $1.name})
                
            } else {
                
                sortedEvents = events.sorted(by: { $0.name > $1.name})
            }
            
            
        } else {
            
            if (sortedBy.lowercased() == "date") {
                
                if (ascendingOrder == true) {
                    
                    sortedEvents = events.sorted(by: {$0.date < $1.date})
                } else {
                    
                    sortedEvents = events.sorted(by: {$0.date > $1.date})
                }
                
            }
        }
        
        self.events = sortedEvents
        
    }
}
