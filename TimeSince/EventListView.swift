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
                VStack(spacing: 50) {
                    
                    ForEach(eventList.events, id: \.id) { event in
                        HStack {
                            EventView(event: event)
                            Spacer()
                        }.padding(10)
                        
                    }
                    
                    
                }
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                .scrollDisabled(false)
                .padding(.bottom, 50)
                
            }.frame(height: geometry.size.height)
            
            
        }
    }
    
    
}


struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        
//        let eventList = EventList(events: [Event(name: "Event 1", date: "01/01/2022"),
//                                Event(name: "Event 2", date: "02/02/2022"),
//                                       Event(name: "Event 3", date: "03/03/2022"),
//                                       Event(name: "Event 4", date: "04/04/2022"),
//
//                                       Event(name: "Event 5", date: "05/05/2022")
//                                       ,
//                                       Event(name: "Event 6", date: "06/06/2022")
//                                       ,
//                                       Event(name: "Event 7", date: "07/07/2022")
//                                       ,
//                                       Event(name: "Event 8", date: "08/08/2022")
//                                       ,
//                                       Event(name: "Event 9 ", date: "09/09/2022"),
//                                       Event(name: "Event 10", date: "10/10/2022")]
//                )
//
//
        let eventList = EventList()
        EventListView(eventList: eventList)
        
    }
}
