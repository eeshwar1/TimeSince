//
//  DropdownButton.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 12/20/22.
//

import SwiftUI

struct DropdownButton: View {
    
    @Binding var sortedBy: String
    @Binding var ascendingOrder: Bool

    var body: some View {
        
        HStack {
            Picker(selection: $sortedBy,
                   label: Text("Sort by")
                      .bold()
                      .font(.system(size:14))
                      .foregroundColor(Color.white))
            {
                
                Label("Name", systemImage: "n.circle").tag("Name")
                Divider()
                Label("Date", systemImage: "d.circle").tag("Date")
            }
            .pickerStyle(.menu)
            .menuStyle(.borderedButton)
            
        
            Button (action: {
                
                ascendingOrder.toggle()
                
            }) {
                
                Label("",systemImage: ascendingOrder ? "arrow.down": "arrow.up")
                    .font(.system(size:20))
                    .bold()
                    .padding(.leading, 10)
                    .frame(width: 30, height: 27)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .border(.yellow)
                    
            }
            .frame(width: 30, height: 40)
            .background(Color.orange).cornerRadius(5)
            .contentShape(Rectangle())
            .keyboardShortcut("a", modifiers: [.command, .shift])
            .help("Sort Order")

            
        }
        .padding(10)
        .frame(width: 200, height: 50)
        .background(Color.orange).cornerRadius(5)

        
       
    }
}

struct DropDownButton_Previews: PreviewProvider {
    static var previews: some View {
        DropdownButton(sortedBy: .constant("Name"), ascendingOrder: .constant(true))
    }
}
