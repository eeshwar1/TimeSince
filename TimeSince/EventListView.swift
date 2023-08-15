//
//  EventListView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 8/13/23.
//

import SwiftUI

struct EventListView: View {
    
    @ObservedObject var eventList = EventList()
    
    var controller: ViewController?
    
    var body: some View {
        
        ScrollView (showsIndicators: false) {
            
            VStack(alignment: .center, spacing: 40) {
                
                ForEach(eventList.getEvents(), id: \.id) { event in
                    VStack {
                        HStack() {
                            EventView(event: event, controller: controller)
                                .contentShape(Rectangle())
                            
                        }
                    }
                }
                
            }
            .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
            
        }
        .padding(10)
        .frame(alignment: .leading)
        
    }
}
