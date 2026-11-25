//
//  TripUsersView.swift
//  caravyn
//
//  Created by Ty Dickson on 11/23/26.
//

import SwiftUI

struct TripUsersView: View {
    
    var trip: Trip
    //@Binding var done: Bool
    
    var body: some View {
        VStack{
            
            AddUserToTripElement(trip: trip)
            
        }
        .padding()
    }
}
