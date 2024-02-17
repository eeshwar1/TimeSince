    //
    //  MonthView.swift
    //  Timeline
    //
    //  Created by Venkateswaran Venkatakrishnan on 1/8/23.
    //

    import SwiftUI

struct MonthView: View {
    
    @State var year: String
    @State var month: String
    @State var monthHeight: CGFloat = 50
    @State var padding: CGFloat = 0
    @State var expandEvents: Bool = false
    @State var eventPadding: CGFloat = -18
    
    @ObservedObject var eventList = EventList()
    
    @State var showingDeleteConfirmation: Bool = false
    
    var controller: ViewController?
    
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    @State var monthEvents: [Event] = []
    
    @State var overMonth = false
    
    var body: some View {
        
        let monthEvents = self.getMonthEvents(year: year, month: month)
        
        HStack(spacing: 0) {
            
            ZStack {
                
                Rectangle()
                    .stroke(lineWidth: 1.0)
                    .border(Color.gray)
                    .frame(width: 400, height: monthHeight, alignment: .topLeading)
                    .offset(CGSize(width: 0, height: monthHeight/2))
                
                HStack(alignment: .center, spacing: 0) {
                    
                    HStack(spacing: 0) {
                        
//                      Rectangle()
//                            .fill(.gray)
//                            .frame(width: 2, height: monthHeight)
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 10, height: 1, alignment: .top)
                        Text("\(month)")
                            .font(.system(size: 8))
                            .multilineTextAlignment(.center)
                            .frame(width: 30, height: 20, alignment: .center)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        
                    }
                    .frame(width: 50, height: 20, alignment: .leading)
                }
                .frame(width: 400, height: monthHeight, alignment: .leading)
                
                
                ZStack {
                    
                    
                    VStack (spacing: eventPadding) {
                        
                        ForEach(monthEvents, id:\.id) {
                            
                            event in
                            VStack {
                                
                                MonthEventView(event: event)
                                
                                
                            }
                            
                        }
                    }
                    if (monthEvents.count > 1 && !expandEvents) {
                                            
                        ZStack {
                            Circle()
                                .stroke(.white)
                                .background(Circle().fill(.red))
                                .frame(width: 20, height: 20, alignment: .leading)
                                .offset(.init(width: 75, height: -10))
                            Text("\(monthEvents.count)")
                                .foregroundColor(Color.white)
                                .offset(.init(width: 75, height: -10))
                        }
                        
                    }
                    
                }
                .frame(alignment: .leading)
                
            }
        }
        .padding(padding)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
             
               expandEvents.toggle()
               eventPadding = expandEvents ? 5: -18
               monthHeight = expandEvents ? CGFloat(monthEvents.count * 50) : 50.0
        
               
        }
        .onHover { over in
               
            overMonth = over
        }
        
    }
    
    func getMonthEvents(year: String, month: String) -> [Event] {
        
        let monthEvents = eventList.getEvents().filter {
            $0.date.getMonth() == month && $0.date.getYear() == year}
        
        return monthEvents
        
        
    }
    
    func deleteEvent(id: UUID) {
        
        // print("Deleting event with id: \(event.id)")
        
        self.showingDeleteConfirmation = false
        
        if let controller = controller {
            controller.deleteEvent(id: id)
        }
    }
    
}

    
extension MonthView {
        
        @ViewBuilder
        private func MonthEventView(event: Event) -> some View {
            
            HStack {
                
                Text(event.name).foregroundColor(.white)
                    .frame(width: 150, alignment: .center)
                    .padding(2)
                    .background(Color.brown).cornerRadius(5)
                    .shadow(color: Color.black, radius: 2, x: 2, y: -2)
                
                if (expandEvents || monthEvents.count == 1) && overMonth {
                    
                    Button {
                        
                        showingDeleteConfirmation = true
                        
                        
                    }
                    label:  { Image(systemName: "minus")
                        
                        .font(.system(size:10))
                        
                    }
                    .help("Delete")
                }
                
            }
            .frame(width: 200, alignment: .leading)
            .confirmationDialog("Delete Event", isPresented: $showingDeleteConfirmation) {
                
                
                Button("Yes") {
                    
                    
                    deleteEvent(id: event.id)
                    
                }
                
                Button("No", role: .cancel) {
                    
                    showingDeleteConfirmation = false
                }
                
                
            } message: {
                Text("Do you want to delete the event \n\"\(event.name)\"")
            }
            
            
        }
        
        
        
    }

//    if (monthEvents.count > 1 && !expandEvents) {
//
//        ZStack {
//            Circle()
//                .stroke(.white)
//                .background(Circle().fill(.red))
//                .frame(width: 20, height: 20, alignment: .leading)
//                .offset(.init(width: 75, height: -10))
//            Text("\(monthEvents.count)")
//                .foregroundColor(Color.white)
//                .offset(.init(width: 75, height: -10))
//        }
//
//    }
//
//
//    }
//
//    }
//    }
//    .padding(padding)
//    .contentShape(Rectangle())
//    .onTapGesture(count: 2) {
//
//    // withAnimation {
//
//    expandEvents.toggle()
//    eventPadding = expandEvents ? 5: -18
//    monthHeight = expandEvents ? CGFloat(monthEvents.count * 30) : 30.0
//    //  }
//
//    }
//    .onHover { over in
//
//    overMonth = over
//    }
//
//
//
//        }
//
//    }



    struct MonthView_Previews: PreviewProvider {
        
        static var previews: some View {
            
            let events = [Event(name: "Republic Day", date: "01/26/2021"), Event(name: "New Year 2021", date: "01/01/2021"),
                Event(name: "New Year 2021", date: "01/01/2021"),
                Event(name: "New Year 2021", date: "01/01/2021")]
            
            MonthView(year: "2023", month: "Jan", padding: 10, expandEvents: true, eventList: EventList(events: events))
        }
    }
