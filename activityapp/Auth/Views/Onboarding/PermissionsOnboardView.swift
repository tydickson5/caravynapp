//
//  PermissionsOnboardView.swift
//  caravyn
//
//  Created by Ty Dickson on 7/10/26.
//

import SwiftUI
import UserNotifications

struct PermissionsOnboardView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var locationHandler: LocationHandler
    
    @State var showWelcomeOnboardView: Bool = true

    @State var notificationsEnabled = false
    @State var locationEnabled = false

    var onComplete: () -> Void
    

    var body: some View {
        if showWelcomeOnboardView {
            WelcomeOnboardView(
                showWelcomeOnboardView: $showWelcomeOnboardView
            )
        } else {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    Text("Permissions")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    ProgressView()

                    Text("Setting up your experience...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                requestPermissions()
            }
        }
    }
    
    func requestPermissions() {
        requestLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            requestNotifications()
        }
    }


    func refreshStatuses() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
        locationEnabled = locationHandler.isAuthorized
    }

    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in

            if let error = error {
                print("Notification authorization error:", error)
            }

            DispatchQueue.main.async {
                notificationsEnabled = granted

                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }

                refreshStatuses()
                finishOnboarding()
            }
        }
    }

    func requestLocation() {
        guard !locationHandler.isAuthorized else {
            locationEnabled = true
            return
        }

        locationHandler.requestPermission()
    }

    func finishOnboarding() {
        if let userId = authStore.user?.id {
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding_\(userId)")
        }
        onComplete()
    }
}

