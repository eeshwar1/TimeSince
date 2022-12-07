//
//  EventList.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/23/22.
//

import Foundation

class EventList: ObservableObject {
    
    var events: [Event]
    
    init() {
        
        self.events = []
    }
    init(events: [Event]) {
        
        self.events = events
    }
    
    func setEvents(events: [Event]) {
        
        self.events = events
    }
}
