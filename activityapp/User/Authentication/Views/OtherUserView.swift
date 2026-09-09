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
    
    @State var user: AppUser
    
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
                
                
                PostListElement(posts: $userPosts)
            

            }
            .padding()
        }
        
        .refreshable {
            //reload posts
            Task {
                let userId = user.id
                userPosts = await retrievePostService.getUsersPosts(userId: userId)
            }
            
        }
        .onAppear{
            //load posts
            Task{
                let userId = user.id
                userPosts = await retrievePostService.getUsersPosts(userId: userId)
            }
            
            
        }
    }
}
