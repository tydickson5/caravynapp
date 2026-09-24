//
//  UserLimitView.swift
//  caravyn
//
//  Created by Ty Dickson on 9/19/26.
//
//  Set limit of users able to use app to avoid $$$$$

import SwiftUI

struct UserLimitView: View {
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            VStack(alignment: .center, spacing: 30){
                Text("Join the Waitlist")
                    .font(.title).bold().foregroundStyle(.dark)
                Text("I am very sorry, but our app is currently full. We will email you when we open more spots.")
                
                Text("Apply to join the waitlist, so you can reserve a spot to use the app before our full release.")
                
                Button(action:{
                    if let url = URL(string: "https://caravyn.com") {
                        openURL(url)
                    }
                }){
                    HStack{
                        Text("Apply to Join")
                            
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .tint(.white)
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.dark)
                        .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                )
            }
            .padding()
        }
        
    }
}

#Preview {
    UserLimitView()
}
