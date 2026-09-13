//
//  OtherUserView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/6/26.
//

import SwiftUI

struct OtherUserView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var postStore: PostStore
    var retrievePostService = RetrievePostService()
    var friendService = FriendService()
    var friendRequestService = FriendRequestService()
    
    var dateFormatterService = DateFormatterService()
    
    @State var userPosts: [Post] = []
    @State var extraPosts: [Post] = []
    
    @State var user: AppUser
    
    var tripService = TripService()
    @State var trips: [Trip] = []
    
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
            ScrollView{
                //profile info
                HStack{
                    Text(user.username)
                        .font(.title)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                
                //friend request
                //check if friend/request exists already
                if(user.id == authStore.user?.id){
                    Text("Your profile")
                }
                else if(friendService.isFriend(friendId: user.id, friends: friendStore.friends)){
                    Text("You are friends!")
                        .padding(.bottom, 10)
                } else if(friendRequestService.friendRequestSent(friendId: user.id, sentFriendRequests: friendStore.sentFriendRequests)) {
                    Text("Request sent!")
                        .padding(.bottom, 10)
                } else if(friendRequestService.friendRequestRecieved(friendId: user.id, recievedFriendRequests: friendStore.recievedFriendRequests)){
                    Text("Check you inbox!")
                        .padding(.bottom, 10)
                } else {
                    Button{
                        Task{
                            guard let u = authStore.user else {return}
                            await friendStore.sendFriendRequest(userId: u.id, friendId: user.id, friendUsername: u.username)

                        }
                        
                    } label: {
                        Label("Send friend request", systemImage: "person.badge.plus")
                            .foregroundStyle(Color.lightBlue)
                            .padding(.bottom, 30)
                    }
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
            .padding()
        }
        
        .refreshable {

            await postStore.loadUserPosts(userId: user.id)
            if let fetchedTrips = await tripService.getUsersTrips(userId: user.id) {
                        trips = fetchedTrips
                    }
            
            extraPosts = postsNotInAnyTrip()
            
        }
        .task {

            await postStore.loadUserPosts(userId: user.id)
            if let fetchedTrips = await tripService.getUsersTrips(userId: user.id) {
                        trips = fetchedTrips
                    }
            
            extraPosts = postsNotInAnyTrip()
        }
    }
}
