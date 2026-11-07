//
//  WelcomeOnboardView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/8/26.
//

import SwiftUI

struct WelcomeOnboardView: View {
    
    @Binding var showWelcomeOnboardView: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("OnboardBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                VStack(alignment: .leading, spacing: 50) {
                    Text("Caravyn")
                        .bold()
                        .foregroundStyle(.dark)
                        .padding(.top, 80)
                    Spacer()
                    Text("Thank you for taking the time to use my app. If you have any suggestions feel free to reach out personally to me at tydickson255@gmail.com. Your feedback will probably get used and will make the app better. Thank you.")
                        .padding()
                        .foregroundStyle(.lightBlue)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Button(action: {
                        showWelcomeOnboardView = false
                    }) {
                        Text("Explore")
                        Image(systemName: "arrow.right")
                    }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.lightBlue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom,30)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .ignoresSafeArea()
    }
}


