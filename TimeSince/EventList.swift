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
    
    var eventYears: [Int]  {
        
        var years : [Int] = []
        for event in events {
            
            let year = Int(event.date.getYear())!
            if !years.contains(year) {
                years.append(year)
            }
            
        }
        return years
    }
    
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
        
        // let _ = print("setSortOrder \(field) : \(ascendingOrder)")
        if (field.lowercased() == "name" ||
            field.lowercased() == "date") {
            
            self.sortedBy = field
            
        } else {
            
            let _ = print("setSortOrder: ERROR Invalid sorted field \(field)")
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
        self.objectWillChange.send()
        
    }
    

    func sortedYearsAsString() -> [String] {
        
        let sortedYears = self.eventYears.map { String($0) }
        
        
        return sortedYears.sorted()
    }
    
    func sortedYears() -> [Int] {
        
        
        return self.eventYears.sorted()
    }
    
}
