//
//  TripListView.swift
//  caravyn
//
//  Created by Ty Dickson on 9/12/26.
//

import SwiftUI

struct TripListElement: View {
    
    var level: Int
    
    var trips: [Trip]
    
    @EnvironmentObject var postStore: PostStore
    
    private func postsInTrip(_ trip: Trip) -> [Post] {
        let start = trip.created_at
        let end = trip.ended_at ?? "9999-12-31T23:59:59+00:00"

        return postStore.userPosts.filter {
            $0.created_at >= start && $0.created_at <= end
        }
    }
    
    var body: some View {
        ForEach(trips) { trip in
            let tripPosts = postsInTrip(trip)
            NavigationLink(destination: TripDetailView(trip: trip, posts: tripPosts)) {
                TripCard(trip: trip, posts: tripPosts)
            }
        }
        
    }
}
