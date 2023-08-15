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
    @State var monthHeight: CGFloat = 40
    @State var padding: CGFloat = 0
    @State var expandEvents: Bool = false
    @State var eventPadding: CGFloat = -18
    
    @ObservedObject var eventList = EventList()
    
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    @State var overMonth = false
    
    var body: some View {
        
        let monthEvents = self.getMonthEvents(year: year, month: month)
        
        HStack(alignment: .center, spacing: 0) {
            Rectangle()
                .fill(.gray)
                .frame(width: 2, height: monthHeight)
            
            HStack {
                
                Rectangle()
                    .fill(.gray)
                    .frame(width: 10, height: 1, alignment: .top)
                Text("\(month)")
                    .font(.system(size: 7))
                
                
            }
            .frame(width: 40, height: 20, alignment: .leading)
            
            ZStack {
                
               
                VStack (spacing: eventPadding){
                      
                    ForEach(monthEvents, id:\.id) {
                        
                        event in
                        VStack {

                            Text(event.name).foregroundColor(.white)
                                .frame(width: 150, alignment: .center)
                                .padding(2)
                                .background(Color.brown).cornerRadius(5)
                                .shadow(color: Color.black, radius: 2, x: 2, y: -2)
                                
                                
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
                
          }
        }
        .padding(padding)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            
           // withAnimation {
                
                expandEvents.toggle()
                eventPadding = expandEvents ? 5: -18
                monthHeight = expandEvents ? CGFloat(monthEvents.count * 30) : 30.0
        //  }
            
        }
        .onHover { over in
            
            overMonth = over
        }
        .onAppear(perform: {
                        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
                            if overMonth {
                              //  print("mouse: \(self.mouseLocation.x) \(self.mouseLocation.y)")
                            }
                            return $0
                        }
                    })
        
       
    }
    
    func getMonthEvents(year: String, month: String) -> [Event] {
         
        let monthEvents = eventList.getEvents().filter {
            $0.date.getMonth() == month && $0.date.getYear() == year}
         
         return monthEvents
         
         
     }
    
    
   
}

struct MonthView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let events = [Event(name: "Republic Day", date: "01/26/2021"), Event(name: "New Year 2021", date: "01/01/2021"),
            Event(name: "New Year 2021", date: "01/01/2021"),
            Event(name: "New Year 2021", date: "01/01/2021")]
        
        MonthView(year: "2023", month: "Jan", padding: 10, expandEvents: true, eventList: EventList(events: events))
    }
}
