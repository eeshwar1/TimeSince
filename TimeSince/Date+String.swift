//
//  Date+String.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/5/22.
//

import Foundation

extension Date {
    
    
    func stringFromDateShort() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func stringFromDateLong() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
    
    func getDateTimeDiff() -> String {
        
        let dateStr:String = self.stringFromDateLong()
        
        let formatter : DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = formatter.string(from: NSDate() as Date)
        let startDate = formatter.date(from: dateStr)
        let endDate = formatter.date(from: now)
        
        // *** create calendar object ***
        var calendar = NSCalendar.current
        
        // *** Get components using current Local & Timezone ***
        // print(calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate!))
        
        // *** define calendar components to use as well Timezone to UTC ***
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let dateComponents = calendar.dateComponents(unitFlags, from: startDate!, to: endDate!)
        
        // *** Get Individual components from date ***
        let years = dateComponents.year!
        let months = dateComponents.month!
        let days = dateComponents.day!
        let hours = dateComponents.hour!
        let minutes = dateComponents.minute!
        let seconds = dateComponents.second!
        
        var timeAgo = ""
        
        if (seconds > 0){
            if seconds < 2 {
                timeAgo = "1 second ago"
            }
            else{
                timeAgo = "\(seconds) second ago"
            }
        }
        
        if (minutes > 0){
            if minutes < 2 {
                timeAgo = "1 minute ago"
            }
            else{
                timeAgo = "\(minutes) minutes ago"
            }
        }
        
        if(hours > 0){
            if hours < 2 {
                timeAgo = "1 hour ago"
            }
            else{
                timeAgo = "\(hours) hours ago"
            }
        }
        
        if (days > 0) {
            if days < 2 {
                timeAgo = "1 day ago"
            }
            else{
                timeAgo = "\(days) days ago"
            }
        }
        
        if(months > 0){
            if months < 2 {
                timeAgo = "1 month ago"
            }
            else{
                timeAgo = "\(months) months ago"
            }
        }
        
        if(years > 0){
            if years < 2 {
                timeAgo = "1 year ago"
            }
            else{
                timeAgo = "\(years) years ago"
            }
        }
        
        // print("timeAgo is ===> \(timeAgo)")
        return timeAgo;
    }
    
    func getDaysSince() -> String {
        
        let dateStr:String = self.stringFromDateLong()
        
        let formatter : DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = formatter.string(from: NSDate() as Date)
        let startDate = formatter.date(from: dateStr)
        let endDate = formatter.date(from: now)
        
        // *** create calendar object ***
        var calendar = NSCalendar.current
        
        // *** Get components using current Local & Timezone ***
        // print(calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate!))
        
        // *** define calendar components to use as well Timezone to UTC ***
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let dateComponents = calendar.dateComponents(unitFlags, from: startDate!, to: endDate!)
        
        // *** Get Individual components from date ***
        let years = dateComponents.year!
        let months = dateComponents.month!
        let days = dateComponents.day!
        
        var daysAgo = ""
        var tailString = ""
        
        if(years > 0){
            
            
            daysAgo = "\(years) years"
            tailString = " ago"
            
        } else {
            
            if (years < 0) {
                
                daysAgo = "\(-1 * years) years"
                tailString = " from now"
            }
        }
        
        if(months > 0){
            
            if (daysAgo == "") {
                daysAgo = "\(months) months"
            } else {
                
                daysAgo = daysAgo + " \(months) months"
            }
            
            tailString = " ago"
        } else {
        
            if (months < 0) {
                
                if (daysAgo == "") {
                    
                    daysAgo = "\(-1 * months) months"
                } else {
                    
                    daysAgo = daysAgo + " and \(-1 * months) months"
                }
                
                tailString = " from now"
            }
            
        }
        
        if (days > 0) {
            
            if (daysAgo == "") {
                daysAgo = "\(days) days"
            } else {
                
                daysAgo = daysAgo + " and \(days) days"
            }
            tailString = " ago"
           
            
        } else {
            
            if (days < 0) {
                
                if (daysAgo == "") {
                    daysAgo = "\(-1 * days) days"
                } else {
                    
                    daysAgo = daysAgo + " and \(-1 * days) days"
                }
                
            }
        
            
            tailString = " from now"
            
        }
        
       
        
       
        
        return daysAgo + tailString;
    }
    
}

extension String {
    
    
    func dateFromString() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.date(from: self) ?? Date()
        
        
    }
}



