//
//  TripDatesElement.swift
//  caravyn
//
//  Created by Ty Dickson on 9/30/26.
//

import SwiftUI

struct TripDatesElement: View {
    
    @State var startDate: String
    @State var endDate: String?
    
    func pullDate(timestamp: String?) -> String{
        
        guard timestamp != nil else {return "Now"}
        
        let formats = [
            "yyyy-MM-dd HH:mm:ss.SSSSSSX",
            "yyyy-MM-dd HH:mm:ssX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX",
            "yyyy-MM-dd'T'HH:mm:ssX"
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        for format in formats {
            formatter.dateFormat = format
            
            if let date = formatter.date(from: timestamp!) {
                let outputFormatter = DateFormatter()
                outputFormatter.locale = Locale(identifier: "en_US_POSIX")
                outputFormatter.dateFormat = "M/d"
                
                return outputFormatter.string(from: date)
            }
        }
        
        return "Now"
    }
    
    var body: some View {
        HStack{
            Image(systemName: "calendar.circle").tint(.lightBlue)
            Text("\(startDate)-\(endDate ?? "Now")")
                .tint(.lightBlue)
        }
        .task {
            startDate = pullDate(timestamp: startDate)
            endDate = pullDate(timestamp: endDate)
        }
    }
}
