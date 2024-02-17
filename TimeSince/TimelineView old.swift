//
//  TimelineView.swift
//  Timeline
//
//  Created by Venkateswaran Venkatakrishnan on 1/8/23.
//

import SwiftUI

struct TimelineView: View {
    
    @ObservedObject var eventList: EventList

    @State var addNew: Bool = false
        
    var controller: ViewController?

    var body: some View {
        
        GeometryReader { (geometry) in
            
            NavigationStack {
                
            ZStack {
                VStack {
                    
                ActionBar
                
                Divider()
                
                EventTimelineView
                
            }
                
            .padding()
            
            }
                
            }
            .padding(10)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
        
            if addNew {
                
                NewEventView(addNew: $addNew, controller: controller)
                    .zIndex(100)
                
            }
        
        }
        
            
    }
    
    func getYearEvents(year: String) -> [Event] {
        
        let yearEvents = eventList.getEvents().filter { $0.date.getYear() == year}
        
        return yearEvents
        
        
    }
                        
    func executeAdd() {
    
            
        self.addNew = true
                

    }
}

extension TimelineView {
    
    private var ActionBar: some View {
        
        HStack {
            
            Button {
                executeAdd()
                
            }
            label:  { Image(systemName: "plus")
                
                    .font(.system(size:14))
                
            }
            .keyboardShortcut("n")
            .help("New Event")
            .disabled(addNew)
            
            NavigationLink(destination: EventListView(eventList: eventList), label: { Image(systemName: "calendar.day.timeline.leading")})
            
        }
        .frame(alignment: .leading)
        
    }
    
    private var EventTimelineView: some View {
        
        ScrollView {
            
            VStack (spacing: 0) {
                
                let years = eventList.eventYears.sorted()
                ForEach(years.indices, id: \.self) { index in
                    
                    VStack (spacing: 0) {
                        
                        YearView(year: String(years[index]), eventList: EventList(events: getYearEvents(year: String(years[index]))))
                        if ((index < years.count - 1) &&
                            (years[index] + 1 < years[index + 1])) {
                            
                            Rectangle()
                                .fill(.bar)
                                .frame(width: 500, height: 10, alignment: .leading)
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        .padding()
        .frame(width: 500, alignment: .leading)
        .scrollDisabled(false)
        
    }
}
struct TimelineView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let events = [Event(name: "New Year 2022", date: "01/01/2022"), Event(name: "New Year 2021", date: "01/01/2021"), Event(name: "New Year 2023", date: "01/01/2023")]
        
       TimelineView(eventList: EventList(events: events))
    }
}



