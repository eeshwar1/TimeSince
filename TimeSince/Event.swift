//
//  VEvent.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/5/22.
//

import Foundation
import CoreData

class Event: Identifiable {
    
    var _id: UUID
    
    var id: UUID {
        get { return self._id }
        set { self._id = newValue }
    }
    var name: String
    var date: Date
    var addedDate: Date?
    var modifiedDate: Date?
    
    var dateValue: String {
        
        date.stringFromDateShort()
    }
    
    var timeSince: String {
        
        date.getDateTimeDiff()
        
    }
    
    var daysSince: String {
        
        date.getDaysSince()
        
    }
    
    init() {
        
        self._id = UUID()
        self.name = "unnamed event"
        self.date = Date()
        self.addedDate = Date()
    }
    
    init(name: String, date: String) {
        
        
        self._id = UUID()
        self.name = name
        self.date = date.dateFromString()
        self.addedDate = Date()
        
    }
    
    init(name: String, date: String, id: UUID) {
        
        self._id = id
        self.name = name
        self.date = date.dateFromString()
        self.addedDate = Date()
        
    }
    
    func asDict() -> [String: Any] {
        
        let dict: [String: Any] = [
            "name": name,
            "date": date.stringFromDateShort()]
        
        return dict
    }
    
    func setName(_ name: String) {
        
        self.name = name
    }
    
}
