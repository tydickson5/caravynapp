//
//  BlockService.swift
//  caravyn
//
//  Created by Ty Dickson on 10/22/26.
//

import Supabase
struct BlockService {
    
    //get all user ids that are blocked
    func getBlockedUsers(userId: String) async -> [String] {
        do {
            let fetched: [String] = try await SupabaseHandler.client.from("block_user").select("blocked_user_id").eq("userId", value: userId).execute().value
            
            return fetched
        } catch {
            print(error)
            return []
        }
    }
    
    //blocks user and returns their user id
    func blockUser(userId: String, blockUserId: String) async -> String?{
        do {
            let fetched: String = try await SupabaseHandler.client.from("block_user").insert([
                "user_id": userId,
                "blocked_user_id": blockUserId
            ]).select("block_user_id").single().execute().value
            
            return fetched
        } catch {
            print(error)
            return nil
        }
    }
    
    func unblockUser(userId: String, blockedUserId: String) async -> Bool {
        do {
            try await SupabaseHandler.client.from("block_user").delete().eq("user_id", value: userId).eq("blocked_user_id", value: blockedUserId).execute()
            
            return true
        } catch {
            print(error)
            return false
        }
    }
}
