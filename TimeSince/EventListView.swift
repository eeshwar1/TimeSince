//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI

struct EventListView: View {
    
    @StateObject var eventList = EventList()
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
            ScrollView {
                
                VStack(alignment: .center, spacing: 100) {
                    
                    ForEach(eventList.events, id: \.id) { event in
                        VStack {
                            HStack(spacing: 10) {
                                EventView(event: event)
                                Spacer()
                                Button("-", action: { executeDelete(id: event.id) })
                           }
                            
                        }
                        
                        
                    }
                    
                    
                }
                .padding(.init(top: 50, leading: 0, bottom: 50, trailing: 0))
                
                
                
            }
            .padding(10)
            .scrollDisabled(false)

            
            
            
        }
    }
    
    func executeDelete(id: UUID) {
        
        print("Deleting event with id: \(id)")
        
        
    }
    
    
}


struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let eventList = EventList(events: [Event(name: "This is a really long event name that will wrap",                                   date: "01/01/2022"),
                                           Event(name: "Event 2", date: "02/02/2022"
                                                ),
                                           Event(name: "Event 3", date: "02/02/2022"
                                                ),
                                           Event(name: "Event 4", date: "02/02/2022"
                                                )
                                        ]
        )
        
        EventListView(eventList: eventList)
            .frame(maxHeight: .infinity)
        
    }
}
