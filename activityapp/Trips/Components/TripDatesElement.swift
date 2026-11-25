//
//  TripDatesElement.swift
//  caravyn
//
//  Created by Ty Dickson on 9/30/26.
//

import SwiftUI

struct TripDatesElement: View {
    
    let startDate: String
    let endDate: String?
    
    private static let inputFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    private static let outputFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "M/d"
        return f
    }()
    
    private static let formats = [
        "yyyy-MM-dd HH:mm:ss.SSSSSSX",
        "yyyy-MM-dd HH:mm:ssX",
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX",
        "yyyy-MM-dd'T'HH:mm:ssX"
    ]
    
    private func pullDate(_ timestamp: String?) -> String {
        guard let timestamp else { return "Now" }
        
        for format in Self.formats {
            Self.inputFormatter.dateFormat = format
            if let date = Self.inputFormatter.date(from: timestamp) {
                return Self.outputFormatter.string(from: date)
            }
        }
        return "Now"
    }
    
    var body: some View {
        HStack {
            Image(systemName: "calendar.circle")
            Text("\(pullDate(startDate))-\(pullDate(endDate))")
        }
        .foregroundStyle(.lightBlue)
    }
}
