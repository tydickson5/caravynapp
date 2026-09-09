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
    var retrievePostService = RetrievePostService()
    
    @ObservedObject var pendingStore = PendingPostService.shared
    
    
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
                }
                
                
                StartTripButton()
                NavigationLink {
                    TripsView()
                } label: {
                    Text("My Trips")
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                if(!pendingStore.pendingPosts.isEmpty){
                    ForEach(pendingStore.pendingPosts){ result in
                        HStack{
                            if let image = pendingStore.previewImage(for: result) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 65, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                // fallback placeholder, e.g.:
                                Image(systemName: "photo")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 65, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Spacer()
                            Button(action:{
                                pendingStore.remove(result)
                            }){
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(Color.red)
                            }
                            .buttonStyle(.borderless)
                        }
                        
                        
                    }
                    
                }
                PostListElement(posts: $postStore.userPosts)
            }
            .padding()

        }
        
        .refreshable {
            if let userId = authStore.user?.id {
                await postStore.loadUserPosts(userId: userId)
            }
            
        }
        .onAppear {
            Task {
                if let userId = authStore.user?.id {
                    await postStore.loadUserPosts(userId: userId)
                }
            }
        }
    }
    
}
