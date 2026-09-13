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
    var retrievePostServie = TripService()
    
    var trip: Trip
    @State var posts: [Post]
    
    var body: some View {
        ScrollView {
            Text(trip.name)
            PostListElement(posts: $postStore.userPosts, trip: trip)
        }
        .padding()
    }
}
