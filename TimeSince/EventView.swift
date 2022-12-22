//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI

struct EventView: View {
    
    @State var event: Event
    
    // TODO: Colors do not work well in Dark Mode. Text is not readable
    
    @State var fgPrimaryColor = Color.primary
    @State var fgAccentColor = Color.accentColor
    
    @State var inEditMode:  Bool = false
    
    @State var showingDeleteConfirmation: Bool = false
    
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
                                            Button("Cancel",action: { inEditMode = false })
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
                                    
                                    self.inEditMode = true
                                }
                                
                                label: {
                                    
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 14))
                                        .bold()

                                }
                                 .help("Edit")
                                
                                
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
                    .background(Color.white).cornerRadius(10)
                    .shadow(radius: 2, x: 0, y: 5)
                    .onTapGesture {
                        
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
            Text("Do you want to delete the event \"\(event.name)\"")
        }
        
        
    }
    
    func updateEvent() {
        
        self.inEditMode = false
        
        if let controller = controller {

            controller.updateEvent(event: event)
        }
    }
    
    
    func deleteEvent() {
            
        print("Deleting event with id: \(event.id)")
        
            self.showingDeleteConfirmation = false
            
            if let controller = controller {
                controller.deleteEvent(id: event.id)
            }
        
        
    }
    
    func enterEditMode() {
        
        // TODO: Preserve previous values in Edit Mode. Right now typing a new Name or selecting a new date will cause the values to be retained in the UI but not written to the database.
        self.inEditMode = true
        
    }
       
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        
        EventView(event: Event(name: "Demo Event", date: "10/01/2022"))

    }
}
