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
    
    @State var currentEvent = Event()
    @State var currentEventID: UUID = UUID()
    
    @State var sortedBy: String = "Name"

    @State var ascendingOrder: Bool = true
    
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
                        .help("New Event")
                        
//
//                        SortButton(field: "Name")
//                        SortButton(field: "Date")
                
                        DropdownSortButton(sortedBy: $sortedBy.didSet({ newValue in setSortOrder()}),
                                       ascendingOrder: $ascendingOrder.didSet( { newValue in setSortOrder()}),
                                           bgColor: Color.blue,
                                       fgColor: Color.white)
                            

                        
                    }
                    .padding(10)
                    .frame(width: geometry.size.width, height: 80, alignment: .leading)
                    
                    EventStack
                        
                }
                .onAppear(
                
                    perform: { let sortOrder = self.eventList.getSortOrder()
                        
                        self.sortedBy = sortOrder.sortedBy
                        self.ascendingOrder = sortOrder.ascendingOrder
                    }
                )
                .confirmationDialog("Delete Event", isPresented: $showingConfirmation) {
                    
                            
                            Button("Yes") {
                               
                                executeDelete(id: currentEventID)
                            }
                    
                            Button("No", role: .cancel) {
                                
                                
                            }
                        
                            
                } message: {
                    Text("Do you want to delete the event \"\(currentEvent.name)\"")
                }
                
                if addNew {

                    NewEventView(addNew: $addNew, controller: controller)
                      
                }
                
                if editEvent {
                    
                    EventDetailsView(editEvent: $editEvent, event: currentEvent, controller: controller)
                }
                
            }
        }
    }
    
    func executeDelete(id: UUID) {
            
            print("Deleting event with id: \(id)")
        
            self.showingConfirmation = false
            
            if let controller = controller {
                controller.deleteEvent(id: id)
                
            }
    }
        
    func executeAdd() {
        
        self.addNew = true
        
        
    }
        
    func setSortOrder() {
        
        self.eventList.setSortOrder(field: sortedBy, ascendingOrder: ascendingOrder)
        
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
                                    self.currentEvent = event
                                    
                                }
                            
                            Button(action:
                                    {
                                 
                                self.editEvent = true
                                self.currentEvent = event
                                
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
                                    .help("Edit")
                            
                            Button(action:
                                    {
                                showingConfirmation = true
                                currentEventID = event.id
                                currentEvent = event
                                
                            }) {
                                Label("",systemImage: "delete.backward")
                                    .font(.system(size:20))
                                    .bold()
                                    .frame(width: 50, height: 50)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 50, height: 50)
                            .background(Color.red).cornerRadius(10)
                            .help("Delete")
                            
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
            
            self.sortedBy = field
            
            self.ascendingOrder.toggle()

            setSortOrder()
            
        } label: {
            
            if (sortedBy == field) {
                
                
                Label("Sort by " + field, systemImage: ascendingOrder ? "arrow.down": "arrow.up")
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

struct SortButtonEx: View {
    
    @State var showDropDown: Bool = false
    @State var sortedBy = "Name"
    @State var ascendingOrder: Bool = false
    var field = "Name"
    
    var body: some View {
        
        ZStack {
            Button {
                
                showDropDown = true
                
            }
        label: {
            
            Text("Sort by " + field)
                .bold()
                .padding(10)
                .frame(width: 150, height: 50)
                .background(Color.orange)
                .foregroundColor(Color.white)
            
            }
            .frame(width: 150, height: 50)
            .background(Color.orange).cornerRadius(10)
            .keyboardShortcut("s")
            
            if showDropDown {
                
                VStack(spacing: 0) {
                    Button {
                        showDropDown = false
                        
                    }
                    
                    label: { Text("Name")
                            .bold()
                            .padding(10)
                            .frame(width: 150, height: 50)
                            .background(Color.yellow)
                        .foregroundColor(Color.white)
                        
                    
                    }
                    .frame(width: 150, height: 50)
                    .background(Color.yellow).cornerRadius(5)
                
                    Button {
                        showDropDown = false
                        
                    }
                    
                    label: { Text("Date")
                            .bold()
                            .padding(10)
                            .frame(width: 150, height: 50)
                            .background(Color.yellow)
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 50)
                    .background(Color.yellow).cornerRadius(5)
            

                    
                }.padding(.top, 150)
                
                 
            }
            
        }
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

extension Binding {
    func didSet(_ didSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }
}
