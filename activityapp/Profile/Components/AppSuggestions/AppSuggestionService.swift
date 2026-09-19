//
//  AppSuggestionService.swift
//  caravyn
//
//  Created by Ty Dickson on 9/19/26.
//

import Supabase


struct AppSuggestionService {
    
    func addSuggestion(userId: String, suggestion: String) async -> Bool {
        do {
            try await SupabaseHandler.client
                .from("app_suggestions")
                .insert([
                    "user_id": userId,
                    "suggestion": suggestion
                ])
                .execute()
            ToastManager.shared.success("Success. Thank you")
            return true
        } catch {
            ToastManager.shared.error("Error")
            return false
        }
    }
}
