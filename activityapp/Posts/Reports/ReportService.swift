//
//  ReportService.swift
//  caravyn
//
//  Created by Ty Dickson on 9/21/26.
//

import Supabase
struct ReportService {
    
    func createPostReport(userId: String, postId: String, reason: String) async -> Bool {
        do {
            try await SupabaseHandler.client.from("post_reports").insert([
                    "user_id": userId,
                    "post_id": postId,
                    "reason": reason
                ])
                .execute()
            
            ToastManager.shared.success("Thank you for reporting")
            return true
        } catch {
            ToastManager.shared.error("Error. Try again")
            print(error)
            return false
        }
    }
    
    func createCommentReport(userId: String, commentId: String, reason: String) async -> Bool {
        do {
            try await SupabaseHandler.client.from("comment_reports").insert([
                    "user_id": userId,
                    "comment_id": commentId,
                    "reason": reason
                ])
                .execute()
            
            ToastManager.shared.success("Thank you for reporting")
            return true
        } catch {
            ToastManager.shared.error("Error. Try again")
            return false
        }
    }
}
