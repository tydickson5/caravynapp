//
//  UsersInTripElement.swift
//  caravyn
//
//  Created by Ty Dickson on 11/24/26.
//

import SwiftUI

struct UsersInTripElement: View {
    
    var tripUsers: [AppUser]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tripUsers) { user in
                    NavigationLink {
                        OtherUserView(user: user)   // your profile view here
                    } label: {
                        Text(user.username)
                            .font(.subheadline)
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color.lightBlue.opacity(0.15))
                            )
                            .overlay(
                                Capsule().stroke(Color.lightBlue.opacity(0.4), lineWidth: 1)
                            )
                            .foregroundStyle(.lightBlue)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 1)   // keeps the capsule stroke from getting clipped
        }
    }
}
