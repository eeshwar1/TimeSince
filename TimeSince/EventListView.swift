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
    @State var editEvent: Bool  = false
    
    @State var event: Event = Event()
    
    @State var sortedBy: String = "date"
    @State var ascendingOrder: Bool = false
    
    @State var showingConfirmation: Bool = false
    
    var controller: ViewController?
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
            ZStack {
                VStack {
                    HStack {
                        
                        Button(action: { executeAdd() }) {
                            Label("",systemImage: "plus")
                                .bold()
                                .font(.system(size:20))
                                .padding([.leading, .bottom], 10)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 50, height: 50)
                        .background(Color.blue).cornerRadius(10)
                        .keyboardShortcut("n")
                        
                            
                        SortButton(field: "name")
                        SortButton(field: "date")

                        
                    }
                    .padding(10)
                    .frame(width: geometry.size.width, height: 80, alignment: .leading)
                    
                    EventStack
                        
                }.confirmationDialog("Delete Event", isPresented: $showingConfirmation) {
                    
                            Button("Yes") {
                                
                                executeDelete(id: event.id)
                            }
                            Button("No", role: .cancel) {
                            }
                        
                    
                } message: {
                    Text("Do you want to delete the event?")
                }
                
                if addNew {

                    NewEventView(addNew: $addNew, controller: controller)
                      
                }
                
                if editEvent {
                    
                    EventDetailsView(editEvent: $editEvent, event: event, controller: controller)
                }
                
            }
        }
    }
    
    func executeDelete(id: UUID) {
            
            //        print("Deleting event with id: \(id)")
        
            self.showingConfirmation = true
            
            if let controller = controller {
                controller.deleteEvent(id: id)
                
            }
    }
        
    func executeAdd() {
        
        self.addNew = true
        
        
    }
        
    func executeSort(by field: String) {
        
//        print("executeSort")
        
        self.sortedBy = field
        
        self.ascendingOrder.toggle()
        
        if let controller = controller {
            
            controller.sortEvents(by: self.sortedBy, ascendingOrder: ascendingOrder)
        }
        
    }
        
}


extension EventListView {
    
    private var EventStack: some View {
        
        ScrollView {
            
            VStack(alignment: .center, spacing: 50) {
                
                ForEach(eventList.getEvents(), id: \.id) { event in
                    VStack {
                        HStack() {
                            EventView(event: event)
                                .contentShape(Rectangle())
                                .onTapGesture{
                                    
                                    self.editEvent = true
                                    self.event = event
                                    
                                }
                            
                            Button(action:
                                    {
                                 
                                self.editEvent = true
                                self.event = event
                                
                            }) {
                                Label("",systemImage: "square.and.pencil")
                                    .bold()
                                    .font(.system(size:20))
                                    .padding(10)
                                    .frame(width: 50, height: 50)
                                    .background(Color.yellow)
                                    .foregroundColor(Color.white)
                            }
                                    .frame(width: 50, height: 50)
                                                                .background(Color.yellow).cornerRadius(10)
                            
                            Button(action:
                                    {
                                 showingConfirmation = true
                                
                            }) {
                                Label("",systemImage: "delete.backward")
                                    .bold()
                                    .font(.system(size:20))
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
            .padding(.init(top: 20, leading: 10, bottom: 50, trailing: 10))
             
        }
        .padding(10)
        .scrollDisabled(false)
         
    }
    
    func SortButton(field: String) -> some View {
        
        
        return Button {
            executeSort(by: field)
            
        } label: {
            
            if (sortedBy == field) {
                
                
                Label("Sort by " + field, systemImage: ascendingOrder ? "arrow.up": "arrow.down")
                    .bold()
                    .padding(10)
                    .frame(width: 150, height: 50)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
            } else {
                
                Text("Sort by " + field)
                    .bold()
                    .padding(10)
                    .frame(width: 150, height: 50)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
            }
            
            
        }
       .frame(width: 150, height: 50)
       .background(Color.orange).cornerRadius(10)
       .keyboardShortcut("s")
        
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
