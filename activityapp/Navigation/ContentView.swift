//
//  ContentView.swift
//  activityapp
//
//  Created by Ty Dickson on 5/5/26.
//

import SwiftUI
import Supabase

struct ContentView: View {
    
    @Environment(\.appEnvironment) var env
    @Environment(\.appDelegate) var appDelegate
    
    var retrievePostService = RetrievePostService()
    var tripService = TripService()
    
    var client: SupabaseClient {
        SupabaseClient(
            supabaseURL: URL(string: env.supabaseUrl)!,
            supabaseKey: env.supabaseAnonKey
        )
    }
    
    func processPostNotification(postId: String) {
        print("🔥 Processing:", postId)

        Task {
            if let post = await retrievePostService.getPost(postId: postId) {
                print("Found post:", post.id)

                await MainActor.run {
                    navigationHandler.selectedPost = post
                    appDelegate.pendingPostId = nil
                }
            } else {
                print("Failed to load post")
            }
        }
    }
    
    func processTripNotification(tripId: String) {
        print("Processing: ", tripId)
        Task {
            if let trip = await tripService.getTripById(tripId: tripId) {
                print("Found trip: ", trip.id)
                
                await MainActor.run{
                    navigationHandler.selectedTrip = trip
                    appDelegate.pendingTripId = nil
                }
            }
        }
    }
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var groupHandler: GroupsHandler
    @EnvironmentObject var postStore: PostStore
    @EnvironmentObject var locationHandler: LocationHandler
    @EnvironmentObject var navigationHandler: NavigationHandler
    @EnvironmentObject var friendStore: FriendStore
    
    
    @StateObject var userLimitCalculator = UserLimitCalculator()
    
    @State var userView = 0
    
    var body: some View {
        
        ZStack{
            if userLimitCalculator.isLoading {
                Text("Welcome to Caravyn")
                    .padding(.bottom, 5)
                    .foregroundStyle(Color.dark)
                
            } else {
                if userLimitCalculator.numberOfUsers > SupabaseHandler.maxNumberOfUsers {
                    UserLimitView()
                } else {
                    if authStore.isAuthenticated, let user = authStore.user{
                        if(authStore.needsOnboarding){
                            PermissionsOnboardView(onComplete: {
                                authStore.needsOnboarding = false
                                })
                                .environmentObject(authStore)
                                .environmentObject(locationHandler)
                        } else {
                            TabView(selection: $userView){
                                HomeView().id(1)
                                    .tabItem { Label("Map", systemImage: "map.fill") }
                                    .tag(0)

                                
                                NewPostView()
                                    .tabItem { Label("Posts",
                                        systemImage: "plus")}
                                    .tag(1)
                                    .environmentObject(postStore)
                                    .environmentObject(authStore)
                                    .environmentObject(locationHandler)

                                FriendsView()
                                    .tabItem { Label("Friends",systemImage: "person")
                                    }
                                    .tag(2)
                                    .environmentObject(friendStore)
                                AccountView()
                                    .tabItem{
                                        Label("Account", systemImage: "person.crop.circle.fill")
                                    }
                                    .tag(3)
                            }
                            .tint(Color.dark)
                            .onAppear {

                                if let postId = appDelegate.pendingPostId {
                                    processPostNotification(postId: postId)
                                }
                                Task{
                                    await friendStore.loadFriendStoreWithUser(userId: user.id)
                                    
                                    await postStore.loadPosts(userId: user.id, friends: friendStore.friends)

                                }
                                
                                PostUploadQueue.shared.postStore = postStore
                                PostUploadQueue.shared.retryAll()
                            }
                            .onChange(of: authStore.isAuthenticated, initial: true) { _, authenticated in
                                guard authenticated else { return }

                                if let postId = appDelegate.pendingPostId {
                                    appDelegate.pendingPostId = nil
                                    processPostNotification(postId: postId)
                                }
                                if let tripId = appDelegate.pendingTripId {
                                    appDelegate.pendingTripId = nil
                                    processTripNotification(tripId: tripId)
                                }
                                if let friendId = appDelegate.pendingFriendId {
                                    appDelegate.pendingFriendId = nil
                                    userView = 2
                                }
                            }
                            .onReceive(NotificationCenter.default.publisher(for: .notificationTapped)) { notification in
                                print("🔥 Received notificationTapped")

                                guard authStore.isAuthenticated else { return }   // pending values cover this case
                                let info = notification.userInfo ?? [:]

                                if let postId = info["postId"] as? String {
                                    appDelegate.pendingPostId = nil
                                    processPostNotification(postId: postId)
                                }
                                if let tripId = info["tripId"] as? String {
                                    appDelegate.pendingTripId = nil
                                    processTripNotification(tripId: tripId)
                                }
                                if let friendId = info["friendId"] as? String {
                                    appDelegate.pendingFriendId = nil
                                    userView = 2
                                }
                            }
                            .sheet(item: $navigationHandler.selectedPost) { post in
                                PostDetailView(post: post)
                            }
                            .sheet(item: $navigationHandler.selectedTrip) { trip in
                                TripDetailView(trip: trip, posts: navigationHandler.tripPosts)
                            }
                            .task {
                                if(authStore.user!.user_default_view == "home"){
                                    userView = 0
                                } else {
                                    userView = 1
                                }
                            }
                        }
                        

                    }
                    else{
                        if(authStore.isLoading){
                            Text("Welcome to Caravyn")
                                .padding(.bottom, 5)
                                .foregroundStyle(Color.dark)

                        }
                        else{
                            LoginView()
                        }
                    }
                }
            }
        }
        .task{
            await userLimitCalculator.getNumberOfAppUsers()
        }
        .font(.body)
        
         
    }
}
