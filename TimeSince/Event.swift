//
//  VEvent.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/5/22.
//

import Foundation
import CoreData

class Event: Identifiable {

    
    var id: UUID?
    var name: String?
    var date: Date?
    var addedDate: Date?
    var modifiedDate: Date?

    var dateValue: String {

        date?.stringFromDateShort() ?? "Invalid"
    }

    var timeSince: String {

        date?.getDateTimeDiff() ?? "Invalid"

    }

    init() {
        
        self.id = UUID()
        self.name = "unnamed event"
        self.date = Date()
        self.addedDate = Date()
    }

    init(name: String, date: String) {
        
        
        self.id = UUID()
        self.name = name
        self.date = date.dateFromString()
        self.addedDate = Date()

    }

    func asDict() -> [String: Any] {

        let dict: [String: Any] = [
            "name": name ?? "Invalid",
            "date": date?.stringFromDateShort() ?? "Invalid"]

        return dict
    }

    func setName(_ name: String) {
        
        self.name = name
    }
    
}
