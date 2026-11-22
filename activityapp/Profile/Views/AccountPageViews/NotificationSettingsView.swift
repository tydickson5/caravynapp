//
//  NotificationSettingsView.swift
//  caravyn
//
//  Created by Ty Dickson on 10/17/26.
//

/*
 
 all notifications
 
 public posts
 friend posts
 
 friend requests
 
 trip starting from friends
 */

import SwiftUI

struct NotificationSettingsView: View {
    
    @Binding var settings: UserNotificationSettings
    var user: AppUser
    
    var notificationSettingsService = NotificationSettingsService()
        
    var body: some View {
        Form {
            Section(""){
                Toggle("All notifications", isOn: $settings.all).onChange(of: settings.all){ oldVal, newVal in
                    Task {
                        settings = await notificationSettingsService.updateSetting(userId: user.id, col: "all", value: settings.all, settings: settings)
                    }
                    
                }
            }
            Section("Posts"){
                Toggle("Public postings", isOn: $settings.public_posts).onChange(of: settings.public_posts){ oldVal, newVal in
                    Task {
                        settings = await notificationSettingsService.updateSetting(userId: user.id, col: "public_posts", value: settings.public_posts, settings: settings)
                    }
                    
                }
                Toggle("Friend postings", isOn: $settings.friend_posts).onChange(of: settings.friend_posts){ oldVal, newVal in
                    Task {
                        settings = await notificationSettingsService.updateSetting(userId: user.id, col: "friend_posts", value: settings.friend_posts, settings: settings)
                    }
                    
                }
            }
            Section("Friends"){
                Toggle("Friend requests", isOn: $settings.friend_requests).onChange(of: settings.friend_requests){ oldVal, newVal in
                    Task {
                        settings = await notificationSettingsService.updateSetting(userId: user.id, col: "friend_requests", value: settings.friend_requests, settings: settings)
                    }
                    
                }
            }
            Section("Trips"){
                Toggle("Friends starting trips", isOn: $settings.trips).onChange(of: settings.trips){ oldVal, newVal in
                    Task {
                        settings = await notificationSettingsService.updateSetting(userId: user.id, col: "trips", value: settings.trips, settings: settings)
                    }
                    
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .task {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()

            if settings.authorizationStatus == .notDetermined {
                do {
                    let granted = try await center.requestAuthorization(
                        options: [.alert, .badge, .sound]
                    )

                    if granted {
                        await MainActor.run {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                } catch {
                    print("Notification permission error:", error)
                }
            }
        }
    }
}
