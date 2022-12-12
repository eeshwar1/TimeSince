//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI

struct EventListView: View {
    
    @StateObject var eventList = EventList()
    
    @State var addNew: Bool = false
    
    var controller: ViewController?
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
            ZStack {
                VStack {
                    HStack {
                        
                        Button(action: { executeAdd() }) {
                            Text("+")
                                .bold()
                                .padding(10)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 50, height: 50)
                        .background(Color.blue).cornerRadius(10)
                        .keyboardShortcut("n")
                         
                        
                    }
                    .padding(10)
                    .frame(width: geometry.size.width, height: 80, alignment: .leading)
                    
                    EventStack
                 }
                
                if addNew {

                    NewEventView(addNew: $addNew, controller: controller)
                      
                }
                
            }
        }
    }
    
    func executeDelete(id: UUID) {
            
            //        print("Deleting event with id: \(id)")
            
            if let controller = controller {
                controller.deleteEvent(id: id)
                
            }
    }
        
    func executeAdd() {
        
        self.addNew = true
        
        
    }
        
        
}


extension EventListView {
    
    private var EventStack: some View {
        
        ScrollView {
            
            VStack(alignment: .center, spacing: 50) {
                
                ForEach(eventList.events, id: \.id) { event in
                    VStack {
                        HStack() {
                            EventView(event: event)
                            Button(action:
                                    {
                                 executeDelete(id: event.id)
                                
                            }) {
                                Text("-")
                                    .bold()
                                    .padding(10)
                                    .frame(width: 50, height: 50)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                            }
                                    .frame(width: 50, height: 50)
                                    .background(Color.red).cornerRadius(10)
                             
                        }
                    }
                }
            }
            .padding(.init(top: 20, leading: 0, bottom: 50, trailing: 0))
             
        }
        .padding()
        .scrollDisabled(false)
         
    }
    
}
struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let eventList = EventList(events: [Event(name: "This is a really long event name that will be truncated",                                   date: "01/01/2022"),
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
