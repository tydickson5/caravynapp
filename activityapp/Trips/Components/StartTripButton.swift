//
//  StartTripButton.swift
//  caravyn
//
//  Created by Ty Dickson on 8/23/26.
//

import SwiftUI

struct StartTripButton: View {
    
    @State var createTripSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                createTripSheetPresented.toggle()
            }){
                Text("Start Trip")
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
        .sheet(isPresented: $createTripSheetPresented) {
            CreateTripFlow(createTripSheetPresented: $createTripSheetPresented)
        }
    }
}
