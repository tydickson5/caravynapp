//
//  AddUserToTripElement.swift
//  caravyn
//
//  Created by Ty Dickson on 10/13/26.
//

import SwiftUI

struct AddUserToTripElement: View {
    
    
    
    var trip: Trip
    @State var peopleInTrip: [AppUser] = []
    @State var friendsNotInTrip: [AppUser] = []
    
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var authStore: AuthStore
    var tripService = TripService()
    var friendService = FriendService()
    var backendService = BackendService()
    
    @State private var showFriends = false
    
    func reloadUserGroups() async {
        peopleInTrip = await tripService.getUsersInTrip(tripId: trip.id) ?? []
        
        let friendUsers = await friendService.getUsersFromFriends(friends: friendStore.friends)
        
        friendsNotInTrip = friendUsers.filter { friend in
            !peopleInTrip.contains { person in
                person.id == friend.id
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            
            //list of people in trip (could be not friend)
            VStack(alignment: .leading){
                Text("Members").font(.caption)
                ForEach(peopleInTrip, id: \.id){ user in
                    Divider()
                    HStack{
                        Text(user.username)
                            .padding()
                        Spacer()
                    }
                    
                    
                }
            }
            .frame(maxWidth: .infinity)
            
            //button to drop down list of other friends to add
            HStack{
                Button(action: {
                    showFriends.toggle()
                }) {
                    HStack{
                        Text("Add friends to trip")
                        Image(systemName: !showFriends ? "chevron.right" : "chevron.down")
                    }
                }
                Spacer()
                if showFriends {
                    Button(action: {
                        showFriends.toggle()
                    }) {
                        HStack{
                            Image(systemName: "xmark.circle")
                        }
                    }
                }
                
            }
            .padding(.bottom, 20)
            
            if showFriends {
                //list of users friends not in trip with add buttons
                ForEach(friendsNotInTrip, id: \.id){ user in
                    Divider()
                    HStack{
                        Text(user.username)
                        Spacer()
                        Button(action: {
                            Task {
                                let result = await tripService.addUserToTrip(tripId: trip.id, userId: user.id, backendService: backendService)
                                
                                if(result) {
                                    await reloadUserGroups()
                                }
                            }
                            
                        }){
                            Image(systemName: "plus")
                        }
                        
                    }
                }
            }
            Button(action: {
                Task {
                    if let userId = authStore.user?.id {
                        let result = await tripService.removeUserFromTrip(tripId: trip.id, userId: userId, backendService: backendService)
                        if(result) {
                            await reloadUserGroups()
                        }
                    }
                    
                }
            }) {
                 Text("Leave trip")
                    .frame(maxWidth: .infinity)
                    .frame(height: 15)
                    .tint(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.red)
                    .stroke(Color.red.opacity(0.5), lineWidth: 2)
            )
            
        }
        .task{
            await reloadUserGroups()
        }
        .padding(.top, 20)
        
    }
    
}
