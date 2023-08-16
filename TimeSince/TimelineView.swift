//
//  TimelineView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 8/13/23.
//

import SwiftUI

struct TimelineView: View {
    
    @ObservedObject var eventList = EventList()
    
    var controller: ViewController?
    
    var body: some View {
     
        ScrollView {
            
            VStack (spacing: 0) {
                    
                ForEach(eventList.sortedYears(), id: \.self) { year in
           

                    YearView(year: String(year), eventList: eventList, controller: controller)
    
                    
                    if let idx = eventList.sortedYears().firstIndex(of: year) {
                        
                        let years = eventList.sortedYears()
                        if ((idx < years.count - 1) &&
                            (years[idx] + 1 < years[idx + 1])) {
                            
                            Rectangle()
                                .strokeBorder(Color.green, style: StrokeStyle(lineWidth: 2, dash: [4]))
                                .frame(width: 400, height: 2, alignment: .leading)
                            
                            
                        }
                    }
                    
                }
            
            }
        }
        .padding()
        .frame(width: 500, alignment: .leading)
        .background(Color.white)
        .scrollDisabled(false)
            
    }
    
}

struct TimelineView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let events = [Event(name: "New Year 2022", date: "01/01/2022"), Event(name: "New Year 2021", date: "01/01/2021"), Event(name: "New Year 2023", date: "01/01/2023")]
        
        TimelineView(eventList: EventList(events: events))
    }
}


