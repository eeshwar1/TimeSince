//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI

struct EventView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var event: Event
    
    @State var fgPrimaryColor = Color.primary
    @State var fgAccentColor = Color.accentColor
    
    @State var inEditMode:  Bool = false
    
    @State var showingDeleteConfirmation: Bool = false
    
    @State var previousName: String = ""
    @State var previousDate: Date = Date()
    
    var controller: ViewController?
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
           
            HStack {
                
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            
                            if inEditMode {
                                
                                VStack {
                                    
                                    Form {
                                        
                                        
                                        TextField("Name", text: $event.name )
                                        DatePicker("Date", selection: $event.date,
                                                   displayedComponents: .date)
                                        HStack {
                                            Button("Save",action: { updateEvent() })
                                                .keyboardShortcut(.defaultAction)
                                            
                                            Button("Cancel",action: {
                                                
                                                event.name = previousName
                                                event.date = previousDate
                                                inEditMode = false })
                                                .keyboardShortcut(.cancelAction)
                                        }
                                        
                                        
                                    }
                                }
                                
                            } else {
                                
                                Text(event.name)
                                    .font(.title)
                                    .bold()
                                    .frame(minWidth: 200, alignment: .leading)
                                    .foregroundColor(fgPrimaryColor)
                                    .truncationMode(.tail)
                                    .help(event.name)
                                Spacer()
                                Text(event.daysSince)
                                    .foregroundColor(fgAccentColor)
                                    .font(.body)
                                    .frame(minWidth: 100)
                                
                            }
                            
                            if inEditMode == false {
                                
                                Button {
                                    
                                    enterEditMode()
                                }
                                
                                label: {
                                    
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 14))
                                        .bold()

                                }
                                 .help("Edit")
                                
                                
                                Button {
                                    
                        
                                    print("Clone event")
                                    cloneEvent()
                                    
                                }
                                label: {
                                    
                                    Image(systemName: "square.on.square")
                                        .font(.system(size: 14))
                                        .bold()
    
                                }
                                 .help("Duplicate")
                                
                                Button {
                                    
                        
                                    self.showingDeleteConfirmation = true
                                    
                                }
                                label: {
                                    
                                    Image(systemName: "delete.backward")
                                        .font(.system(size: 14))
                                        .bold()
    
                                }
                                 .help("Edit")
                            }
                            
                           
                            
                        }
                        
                        if inEditMode == false {
                            
                            HStack(alignment: .center) {
                                Text(event.dateValue).foregroundColor(fgPrimaryColor)
                                    .font(.subheadline)
                                    .frame(width: 100, alignment: .leading)
                                Spacer()
                                    .frame(minWidth: 50)
                                
                            }
                            
                        }
                        
                        
                        
                        HStack(alignment: .center) {
                            Text(event.id.uuidString).foregroundColor(fgPrimaryColor.opacity(0.5))
                                .font(.subheadline)
                                .frame(width: 300, alignment: .leading)
                            Spacer()
                                .frame(minWidth: 50)
                        }
                        
                    }
                    .padding(10)
                    .frame(width: geometry.size.width,
                           height: inEditMode ? 120: 100, alignment: .leading)
                    .background(colorScheme == .light ? Color.white : Color.gray).cornerRadius(10)
                    .shadow(radius: 1, x: 1, y: 5)
                    .onTapGesture (count: 2) {
                        
                        self.enterEditMode()
                    }
                    
                    
                }
                
                
            }
            .scrollDisabled(false)
            .frame(width: geometry.size.width,
                   height: 500, alignment: .leading)
                
            }
        .padding(.bottom, 80)
        .padding(.leading, 10)
        .confirmationDialog("Delete Event", isPresented: $showingDeleteConfirmation) {
            
                    
                    Button("Yes") {
                       
                        deleteEvent()
                    }
            
                    Button("No", role: .cancel) {
                        
                        showingDeleteConfirmation = false
                    }
                
                    
        } message: {
            Text("Do you want to delete the event \n\"\(event.name)\"")
        }
        
        
    }
    
    func updateEvent() {
        
        self.inEditMode = false
        
        if let controller = controller {

            controller.updateEvent(event: event)
        }
    }
    
    func cloneEvent() {
        
        if let controller = controller {
            
            controller.addEvent(event: Event(name:event.name + " - copy", date: event.date.stringFromDateShort()))
        }
    }
    
    func deleteEvent() {
            
        // print("Deleting event with id: \(event.id)")
        
            self.showingDeleteConfirmation = false
            
            if let controller = controller {
                controller.deleteEvent(id: event.id)
            }
        
        
    }
    
    func enterEditMode() {
        
        previousName = event.name
        previousDate = event.date
        
        self.inEditMode = true
        
    }
       
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        
        EventView(event: Event(name: "Demo Event", date: "10/01/2022"))

    }
}
