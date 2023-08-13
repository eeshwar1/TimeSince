//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI
import os

struct EventListView: View {
    
    @StateObject var eventList = EventList()
    
    @State var addNew: Bool = false
    @State var editEvent: Bool  = false
    @State var showTimeline: Bool = false
    
    @State var currentEvent = Event()
    @State var currentEventID: UUID = UUID()
    
    @State var sortedBy: String = "Name"
    
    @State var ascendingOrder: Bool = true
    
    @State var showingConfirmation: Bool = false
    
    var controller: ViewController?
    
        
    var body: some View {
        
        GeometryReader { (geometry) in

            
            NavigationStack {
                
                ZStack {
                    
                        VStack {
                            
                            ActionBar
                            
                            Divider()
                            
                            if showTimeline {
                                
                                EventTimelineView
                            }
                            else {
                                
                                EventStack
                                
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
        
        // print("Deleting event with id: \(id)")
        
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


extension EventListView {
    
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
    
    
    private var EventStack: some View {
        
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
    
    private var EventTimelineView: some View {
        
        ScrollView (showsIndicators: false){
            
            VStack (spacing: 0) {
                
                let years = eventList.eventYears.sorted()
                ForEach(years.indices, id: \.self) { index in
                    
                    VStack (spacing: 0) {
                        
                        YearView(year: String(years[index]))
                            
                        if ((index < years.count - 1) &&
                            (years[index] + 1 < years[index + 1])) {
                            
                            Rectangle()
                                .fill(.bar)
                                .frame(width: 600, height: 10, alignment: .leading)
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
        .frame(alignment: .leading)
        
    }
    
    
    func getYearEvents(year: String) -> [Event] {
        
        let yearEvents = eventList.getEvents().filter { $0.date.getYear() == year}
        
        return yearEvents
        
        
    }
                                 
    func getMonthEvents(year: String, month: String) -> [Event] {
         
        let monthEvents = eventList.getEvents().filter { $0.date.getMonth() == month && $0.date.getYear() == year}
         
         return monthEvents
         
         
     }
    
    @ViewBuilder
    func YearView(year: String) -> some View {
        
        let months=["Jan","Feb","Mar","Apr","May",
                        "Jun","Jul","Aug","Sep","Oct",
                        "Nov","Dec"]
        
        let yearHeight: CGFloat = 360.0
        
        HStack(spacing: 0) {
            
            Text("\(year)")
                .offset(.init(width: 0, height: -yearHeight/2 - 40))
                .bold()
                .frame(width: 30, height: 10, alignment: .leading)
                .font(.system(size: 10))
            
            
            VStack(spacing: 0) {
                
                ForEach(months.indices, id: \.self) { index in
                    
                    MonthView(year: year, month: months[index])
                }
                .frame(width: 600, alignment: .leading)
                
            }
        }
    }
    
    @ViewBuilder
    func MonthView(year: String, month: String) -> some View {
        
        let eventPadding: CGFloat = -18
        let expandEvents = false
        let monthHeight: CGFloat = 40
        let monthEventList = EventList(events: getMonthEvents(year: year, month: month))
        
        HStack(alignment: .center, spacing: 0) {
            
            Rectangle()
                .fill(.gray)
                .frame(width: 2, height: monthHeight)
            
            HStack  {
                
                Rectangle()
                    .fill(.gray)
                    .frame(width: 10, height: 1, alignment: .top)
                Text("\(month)")
                    .font(.system(size: 7))
                
                VStack (spacing: eventPadding){

                    ForEach(monthEventList.getEvents(), id:\.id) {

                        event in
                        VStack {

                            Text(event.name).foregroundColor(.white)
                                .frame(width: 150, alignment: .center)
                                .padding(2)
                                .background(Color.brown).cornerRadius(5)
                                .shadow(color: Color.black, radius: 2, x: 2, y: -2)


                        }

                    }

                    if (monthEventList.getEvents().count > 1 && !expandEvents) {

                             ZStack {
                                 Circle()
                                     .stroke(.white)
                                     .background(Circle().fill(.red))
                                     .frame(width: 20, height: 20, alignment: .leading)
                                     .offset(.init(width: 75, height: -10))
                                 Text("\(monthEventList.getEvents().count)")
                                     .foregroundColor(Color.white)
                                     .offset(.init(width: 75, height: -10))
                             }

                    }

                }
             
    
                
                
            }
            .frame(width: 200, height: 20, alignment: .leading)
                    
        }
        .contentShape(Rectangle())
        
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
