//
//  BlockUserButton.swift
//  caravyn
//
//  Created by Ty Dickson on 10/22/26.
//

import SwiftUI

struct BlockUserButton: View {
    
    var userId: String
    var otherUser: AppUser
    
    @State var blocked: Bool = true
    
    var blockService = BlockService()
    
    @EnvironmentObject var postStore: PostStore
    @EnvironmentObject var friendStore: FriendStore
    
    var body: some View {
        Button(action: {
            Task {
                if(blocked) {
                    let result = await blockService.unblockUser(userId: userId, blockedUserId: otherUser.id)
                    
                    if result {
                        blocked = false
                    }
                } else {
                    let result = await blockService.blockUser(userId: userId, blockUserId: otherUser.id)
                    
                    if result != nil {
                        blocked = true
                    }
                }

                await postStore.loadPosts(userId: userId, friends: friendStore.friends)

            }
        }){
            if(!blocked){
                Image(systemName: "person.badge.shield.exclamationmark.fill")
            } else {
                Text("Unblock")
            }
            
        }
        .task {
            let blockedUsers = await blockService.getBlockedUsers(userId: userId)
            if !blockedUsers.contains(otherUser.id) {
                blocked = false
            }
        }
    }
}
