//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI

struct EventView: View {
    
    var event: Event
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
            HStack {
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(event.name ?? "Invalid")
                            .font(.largeTitle)
                            .bold()
                            .frame(minWidth: 300, alignment: .leading)
                        Spacer()
                            .frame(minWidth: 10)
                        Text(event.timeSince)
                            .foregroundColor(.blue)
                            .font(.body)
                            .frame(minWidth: 100)
                    }
                    HStack(alignment: .center) {
                        Text(event.dateValue).foregroundColor(.black)
                            .font(.subheadline)
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                            .frame(minWidth: 50)
                   
                    }
                    HStack(alignment: .center) {
                        Text(event.id.uuidString).foregroundColor(.gray)
                            .font(.subheadline)
                            .frame(width: 300, alignment: .leading)
                        Spacer()
                            .frame(minWidth: 50)
                    }
                   
                }
                .padding(20)
                .frame(width: geometry.size.width - 60,
                       height: geometry.size.height, alignment: .leading)
                
                
                
               
            }
                            
                
                
        }.padding(.bottom, 10)
            
        
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event(name: "Hello World", date: "10/01/2022"))

    }
}
