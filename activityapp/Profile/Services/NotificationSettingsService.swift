//
//  NotificationSettingsService.swift
//  caravyn
//
//  Created by Ty Dickson on 10/17/26.
//

import Supabase
struct NotificationSettingsService {
    
    func getNotificationSettings(userId: String) async -> UserNotificationSettings? {
        do {
            let fetched: UserNotificationSettings = try await SupabaseHandler.client.from("user_notification_settings").select().eq("user_id", value: userId).single().execute().value
            
            return fetched
        } catch {
            print(error)
            ToastManager.shared.error("Error loading settings")
            return nil
        }
    }
    
    func updateSetting(userId: String, col: String, value: Bool, settings: UserNotificationSettings) async -> UserNotificationSettings{
        do {
            let updated: UserNotificationSettings = try await SupabaseHandler.client.from("user_notification_settings").update([
                col: value
            ]).eq("user_id", value: userId).single().execute().value
            
            return updated
        } catch {
            print(error)
            ToastManager.shared.error("Error")
            return settings
        }
    }
}
