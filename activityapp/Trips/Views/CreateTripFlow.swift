//
//  CreateTripFlow.swift
//  caravyn
//
//  Created by Ty Dickson on 11/24/26.
//

import SwiftUI

struct CreateTripFlow: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var createTripSheetPresented: Bool
    @State private var showCreateTripView = true
    @State private var changeToAddFriends = false
    
    var body: some View {
        VStack{
            CreateTripView(showCreateTripView: $showCreateTripView, changeToAddFriends: $changeToAddFriends)
        }
        .onChange(of: showCreateTripView){
            if(!showCreateTripView){
                createTripSheetPresented = false
                dismiss()
            }
        }
    }
}
