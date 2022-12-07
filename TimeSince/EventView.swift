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
                    
                    VStack {
                        HStack {
                            Text(event.name ?? "Invalid")
                                .font(.largeTitle)
                                .bold()
                                .frame(minWidth: 200, alignment: .leading)
                            Spacer()
                                .frame(minWidth: 50)
                            Text(event.timeSince)
                                .foregroundColor(.blue)
                                .font(.body)
                                .frame(minWidth: 100)
                        }
                        HStack {
                            Text(event.dateValue).foregroundColor(.black)
                                .font(.subheadline)
                                .frame(minWidth: 50, alignment: .leading)
                            Spacer()
                                .frame(minWidth: 10)
                            
                            
                        }
                        HStack {
                            Text(event.id?.uuidString ?? "Invalid").foregroundColor(.gray)
                                .font(.subheadline)
                                .frame(minWidth: 300, alignment: .leading)
                            Spacer()
                                .frame(minWidth: 5)
                        }
                        
                        
                        
                    }
                    .frame(width: geometry.size.width - 30, height: 20, alignment: .leading)
                    
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 2))
                    
                    
                    Spacer()
                    Text(event.timeSince)
                }
                
                
                
            }
        
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event(name: "Hello World", date: "10/01/2022"))

    }
}
