//
//  NewEventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 12/11/22.
//

import SwiftUI

struct NewEventView: View {
    
    @State private var name: String = "Event Name"
    
    @State private var date: Date = Date()
    
    var controller: ViewController?
    
    var body: some View {
        
        VStack {
            Text("Add an Event")
                .font(.largeTitle)
                .bold()
            
            Form {
              
                TextField("Name", text: $name)
                DatePicker("Date", selection: $date,
                           displayedComponents: .date)
            
                
            }
            Button("Add",action: addEvent)
                .keyboardShortcut(.defaultAction)
                
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       
        
    }
    
    func addEvent() {
        
        print("Add Event")
        
        if let controller = controller {
            
            controller.addEvent(event: Event(name: name, date: date.stringFromDateShort()))
        }
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView()
    }
}
