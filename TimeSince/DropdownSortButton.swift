//
//  DropdownButton.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 12/20/22.
//

import SwiftUI

struct DropdownSortButton: View {
    
    @Binding var sortedBy: String
    @Binding var ascendingOrder: Bool
    
    @State var bgColor: Color = Color.purple
    @State var fgColor: Color = Color.primary
    @State var borderColor: Color = Color.primary.opacity(0.5)

    var body: some View {
        
        HStack {
            Picker(selection: $sortedBy,
                   label: Text("Sort by")
                      .bold()
                      .font(.system(size:14))
                      .foregroundColor(fgColor))
            {
                
                Label("Name", systemImage: "n.circle").tag("Name")
                Divider()
                Label("Date", systemImage: "d.circle").tag("Date")
            }
            .pickerStyle(.menu)
            .menuStyle(.borderedButton)
            
        
            Button {
                
                ascendingOrder.toggle()
                
            }
        label: {
                
                Image(systemName: ascendingOrder ? "arrow.down": "arrow.up")
                    .font(.system(size:14))
                                        
                    
            }
            
            .keyboardShortcut("s", modifiers: [.command, .shift])
            .help("Sort Order")

            
        }
        .padding(10)
        .frame(maxWidth: 200)
        //.frame(width: 200, height: 50)
        // .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5)
            .stroke(borderColor, lineWidth: 2))
        //.background(bgColor).cornerRadius(5)
        

        
       
    }
    
    func setColor(fgColor: Color, bgColor: Color) {
        
        self.bgColor = bgColor
        self.fgColor = fgColor
    }
}

struct DropDownButton_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSortButton(sortedBy: .constant("Name"), ascendingOrder: .constant(true))
    }
}
