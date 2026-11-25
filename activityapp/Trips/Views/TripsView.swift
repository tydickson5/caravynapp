//
//  TripsView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/23/26.
//

import SwiftUI

struct TripsView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var tripStore: TripStore
    
    @State var tripToShow: Trip? = nil
    
    var body: some View {
        NavigationStack{
            List(tripStore.trips){ trip in

                HStack {
                    Text(trip.name)
                    Spacer()
                    
                    
                    Button(action: {
                        tripToShow = trip
                    }){
                        Image(systemName: "pencil")
                            .foregroundStyle(.lightBlue)
                    }
                    .buttonStyle(.borderless)
                    
                    if(trip.ended_at == nil){
                        EndTripButton(tripId: trip.id){ success in
                            
                            if(success){
                                print("ended")
                                Task{
                                    guard let user = authStore.user else {
                                        return
                                    }
                                    await tripStore.loadTrips(userId: user.id)
                                }
                                
                            }
                        }
                    }

                }
            }
        }
        .sheet(item: $tripToShow) { trip in
            EditTripView(trip: trip, ended: trip.ended_at == nil ? true : false)
        }
    }
}
