//
//  NewEventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 12/11/22.
//

import SwiftUI

struct NewEventView: View {
    
    @Binding var addNew: Bool
    
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
            
            HStack {
                Button("Add",action: { addEvent() })
                    .keyboardShortcut(.defaultAction)
                Button("Cancel",action: { cancelAdd() })
                    .keyboardShortcut(.cancelAction)
            }
                
        }
        .padding(10)
        .frame(maxWidth: 300, maxHeight: 200)
        .border(.gray)
        .background(.regularMaterial.shadow(.drop(color: .black, radius: 10)))
        
        
    }
    
    func addEvent() {
        
        print("Add Event")
        
        self.addNew = false
        
        if let controller = controller {
            
            controller.addEvent(event: Event(name: name, date: date.stringFromDateShort()))
        }
    }
    
    func cancelAdd() {
        
        self.addNew = false
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
    
        
        NewEventView(addNew: .constant(true))
    }
}
