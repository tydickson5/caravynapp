//
//  TripDetailView.swift
//  caravyn
//
//  Created by Ty Dickson on 9/12/26.
//

import SwiftUI

struct TripDetailView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var postStore: PostStore
    var tripService = TripService()
    
    var trip: Trip
    @State var posts: [Post]
    @State var usersInTrip: [AppUser] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    Text(trip.name).font(.title2)
                    Spacer()
                    
                }
                
                HStack{
                    Spacer()
                    TripDatesElement(startDate: trip.created_at, endDate: trip.ended_at ?? "Now")
                }
                UsersInTripElement(tripUsers: usersInTrip)
                Text(trip.description)
                TripMapElement(posts: posts)
            }
            
            .padding(.bottom, 30)
            PostListElement(posts: $posts, trip: trip)
        }
        .padding(.top, 100)
        .padding()
        .background(Color.background)
        .ignoresSafeArea()
        .task{
            //load trips for all users
            let otherMemberPosts = await tripService.getOtherUsersPostsInTrip(tripId: trip.id)
            
            posts = otherMemberPosts
            
            usersInTrip = await tripService.getUsersInTrip(tripId: trip.id)
        }
        .refreshable {
            //load trips for all users
            let otherMemberPosts = await tripService.getOtherUsersPostsInTrip(tripId: trip.id)
            
            posts = otherMemberPosts
            
            usersInTrip = await tripService.getUsersInTrip(tripId: trip.id)
        }
    }
}
