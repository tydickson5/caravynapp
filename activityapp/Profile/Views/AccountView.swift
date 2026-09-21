//
//  AccountView.swift
//  caravyn
//
//  Created by Ty Dickson on 6/17/26.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var postStore: PostStore
    var tripService = TripService()
    var retrievePostService = RetrievePostService()
    
    @State var trips: [Trip] = []
    @State var extraPosts: [Post] = []
    
    @ObservedObject var pendingStore = PendingPostService.shared
    
    private func postsInTrip(_ trip: Trip) -> [Post] {
        let start = trip.created_at
        let end = trip.ended_at ?? "9999-12-31T23:59:59+00:00"

        return postStore.userPosts.filter {
            $0.created_at >= start && $0.created_at <= end
        }
    }
    
    private func postsNotInAnyTrip() -> [Post] {
        let allTripPosts = Set(
            trips.flatMap { postsInTrip($0) }.map { $0.id }
        )

        return postStore.userPosts.filter { !allTripPosts.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                
                if let user = authStore.user {
                    HStack{
                        Text(user.username)
                            .font(.title)
                        Spacer()
                        NavigationLink {
                            AccountSettingsView()
                        } label: {
                            Label("", systemImage: "gearshape.fill")
                        }
                    }
                    .padding(.bottom, 20)
                    StartTripButton()
                    NavigationLink {
                        TripsView()
                    } label: {
                        Text("My Trips")
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    if(!pendingStore.pendingPosts.isEmpty){
                        HStack {
                            Text("\(pendingStore.pendingPosts.count) uploading posts")
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                    TripListElement(level: 1, trips: trips)
                    HStack{
                        Text("Posts not in trip").font(.title3)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                        
                    PostListElement(posts: $extraPosts, trip: nil)
                }
                
                
                
            }
            .padding()

        }
        
        .refreshable {
            guard let user = authStore.user else {
                return
            }
            await postStore.loadUserPosts(userId: user.id)
            if let fetchedTrips = await tripService.getUsersTrips(userId: user.id) {
                        trips = fetchedTrips
                    }
            
            extraPosts = postsNotInAnyTrip()
            
        }
        .task {
            guard let user = authStore.user else {
                return
            }
            await postStore.loadUserPosts(userId: user.id)
            if let fetchedTrips = await tripService.getUsersTrips(userId: user.id) {
                        trips = fetchedTrips
                    }
            
            extraPosts = postsNotInAnyTrip()
        }
    }
    
}
