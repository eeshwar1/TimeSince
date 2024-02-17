    //
    //  TimeSinceView.swift
    //  TimeSince
    //
    //  Created by Venkateswaran Venkatakrishnan on 11/6/22.
    //

    import SwiftUI
    import os



private struct showWeeksKey: EnvironmentKey {
    
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    
    var showWeeks: Bool {
        
        get { self[showWeeksKey.self] }
        set { self[showWeeksKey.self] = newValue}
    }
}

extension View {
    func showWeeks(_ showWeeksValue: Bool) -> some View {
        environment(\.showWeeks, showWeeksValue)
    }
}

    struct TimeSinceView: View {
        
        @ObservedObject var eventList = EventList()
        
        @State var addNew: Bool = false
        @State var editEvent: Bool  = false
        @State var showTimeline: Bool = false
        @State var currentEvent = Event()
        @State var currentEventID: UUID = UUID()
        @State var sortedBy: String = "Name"
        @State var ascendingOrder: Bool = true
        @State var showingConfirmation: Bool = false
        
        
        @State var showWeeks: Bool = false
        
        var controller: ViewController?
        
        var body: some View {
            
            GeometryReader { (geometry) in
                
                NavigationStack {
                    
                    ZStack {
                        
                            VStack {
                                ActionBar
                                
                                Divider()
                                
                                if showTimeline {
                                    
                                    EventTimelineView(eventList: eventList, controller: controller)
                                }
                                else {
                                    
                                    EventStack(eventList: eventList, controller: controller)
                                        .showWeeks(showWeeks)
                                }
                                
                                
                            }
                            .frame(alignment: .leading)
                            .onAppear(
                                
                                perform: { let sortOrder = self.eventList.getSortOrder()
                                    
                                    self.sortedBy = sortOrder.sortedBy
                                    self.ascendingOrder = sortOrder.ascendingOrder
                                }
                            )
                            
                        
                            if addNew {

                               
                                NewEventView(addNew: $addNew, controller: controller)
                                    .transition(.move(edge: .leading))
                                    .zIndex(100)
                           
                            }
                        
                    }
                    
                }
              
            }
        }
        
        func executeDelete(id: UUID) {
            
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
        
        func refreshEvents() {
            
            if let controller = controller {
                
                controller.fetchEvents()
                
            }
        }
       
    }


    extension TimeSinceView {
        
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
                
                Button { refreshEvents() }
                label: {
                    Image(systemName: "arrow.clockwise")
                    
                }
                .buttonStyle(.bordered)
                .keyboardShortcut("r")
                .help("Refresh")
                
               
                Toggle("Show Weeks", isOn: $showWeeks)
                    .toggleStyle(.button)
    	
                
                Button {
                    
                    self.showTimeline.toggle()
                        
                }
                label:  {
                    
                    Image(systemName: self.showTimeline ? "list.bullet": "calendar.day.timeline.leading")
                    
                        .font(.system(size:14))
                    
                }
                .help(self.showTimeline ?  "Show List" : "Show Timeline")
                
              
             
            
                if !showTimeline {
                    DropdownSortButton(sortedBy: $sortedBy.didSet({ newValue in setSortOrder()}),
                                       ascendingOrder: $ascendingOrder.didSet( { newValue in setSortOrder()}))
                }
                
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
                
              
        }
        
        
        @ViewBuilder
        private func EventStack(eventList: EventList, controller: ViewController?) -> some View {
            
            ScrollView (showsIndicators: false) {
                
               EventListView(eventList: eventList, controller: controller)
                
            }
            .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
            .frame(alignment: .leading)
            
        }
        
        @ViewBuilder
        private func EventTimelineView(eventList: EventList, controller: ViewController?) -> some View {
            
            ScrollView (showsIndicators: false) {
                    
                TimelineView(eventList: eventList, controller: controller)
                
            }
            .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
            .frame(alignment: .leading)
            
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
            
            TimeSinceView(eventList: eventList)
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

    struct NavBackButton: View {
        let dismiss: DismissAction
        
        var body: some View {
            Button {
                dismiss()
            } label: {
                Image("...custom back button here")
            }
        }
    }
