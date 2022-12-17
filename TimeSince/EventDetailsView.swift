//
//  NewEventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 12/11/22.
//

import SwiftUI

struct EventDetailsView: View {
    
    @Binding var editEvent: Bool
    
    @State var event: Event
    
//    @State private var name: String = "Event Name"
//
//    @State private var date: Date = Date()
    
    var controller: ViewController?
    
    var body: some View {
        
        VStack {
            Text("Edit Event")
                .font(.largeTitle)
                .bold()
            
            Form {
              
                TextField("Name", text: $event.name )
                DatePicker("Date", selection: $event.date,
                           displayedComponents: .date)
            
                
            }
            
            HStack {
                Button("Save",action: { updateEvent() })
                    .keyboardShortcut(.defaultAction)
                Button("Cancel",action: { cancel() })
                    .keyboardShortcut(.cancelAction)
            }
                
        }
        .padding(10)
        .frame(maxWidth: 300, maxHeight: 200)
        .border(.gray)
        .background(.regularMaterial.shadow(.drop(color: .black, radius: 10)))
        
        
    }
    
    func updateEvent() {
        
        print("Save Event")
        
        self.editEvent = false
        
        if let controller = controller {

            controller.updateEvent(event: event)
        }
    }
    
    func cancel() {
        
        self.editEvent = false
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
    
        let event = Event(name: "Test", date: "12/16/2022")
        EventDetailsView(editEvent: .constant(true), event: event)
    }
}