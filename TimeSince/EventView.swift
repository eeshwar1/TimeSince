//
//  EventView.swift
//  TimeSince
//
//  Created by Venkateswaran Venkatakrishnan on 11/6/22.
//

import SwiftUI

struct EventView: View {
    
    var event: Event
    
    @State var fgPrimaryColor = Color.white
    @State var fgAccentColor = Color.yellow
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
           
                HStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(event.name)
                                .font(.largeTitle)
                                .bold()
                                .frame(minWidth: 200, alignment: .leading)
                                .foregroundColor(fgPrimaryColor)
                            Spacer()
                                .frame(minWidth: 10)
                            Text(event.daysSince)
                                .foregroundColor(fgAccentColor)
                                .font(.body)
                                .frame(minWidth: 100)
                        }
                        HStack(alignment: .center) {
                            Text(event.dateValue).foregroundColor(fgPrimaryColor)
                                .font(.subheadline)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                                .frame(minWidth: 50)
                            
                        }
                        HStack(alignment: .center) {
                            Text(event.id.uuidString).foregroundColor(fgPrimaryColor.opacity(0.5))
                                .font(.subheadline)
                                .frame(width: 300, alignment: .leading)
                            Spacer()
                                .frame(minWidth: 50)
                        }
                        
                    }
                    .padding(20)
                    .frame(width: geometry.size.width - 40,
                           height: 100, alignment: .leading)
                    .background(Color.secondary.opacity(0.5)).cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 4)
                            
                    )
                    
                    
                }
                
                
            }
        .padding(.bottom, 45)
        .padding(.leading, 10)
        
        
    }
        
       
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event(name: "Demo Event", date: "10/01/2022"))

    }
}
