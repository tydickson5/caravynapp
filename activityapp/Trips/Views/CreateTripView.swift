//
//  CreateTripView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/23/26.
//

import SwiftUI

struct CreateTripView: View {
    
    @Binding var showCreateTripView: Bool
    @Binding var changeToAddFriends: Bool
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var tripStartDate = Date()
    @State private var tripEndDate = Date()
    @State private var isSubmitLoading: Bool = false
    
    @State private var newTrip: Bool = true
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var tripStore: TripStore
    var dateFormatterService = DateFormatterService()
    //var tripService = TripService()
    
    var body: some View {
        
        NavigationStack {
            VStack(){
                Picker("View", selection: $newTrip) {
                    Text("Now").tag(true)
                    Text("Previous").tag(false)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            if(newTrip){
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading){
                        TextField("Trip name", text: $name)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                            )
                    }
                    VStack(alignment: .leading){
                        Text("Description")
                            .font(.footnote)
                        TextEditor(text: $description)
                            .frame(height: 150)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                            )
                    }
                    
                    
                    
                    Button(action: {
                        isSubmitLoading = true
                        defer {isSubmitLoading = false}
                        guard let user = authStore.user else {
                            return
                        }
                        Task {
                            let result = await tripStore.startTrip(userId: user.id, username: user.username, name: name, description: description)
                            if(result){
                                name = ""
                                description = ""
                                //go to add user page?
                                showCreateTripView = false
                            }
                        }
                        
                    }) {
                        Text("Start")
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
                    .disabled(name == "")
                    .disabled(isSubmitLoading)
                }
                .navigationTitle("New Trip")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showCreateTripView = false
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .padding()
            } else {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading){
                        TextField("Trip name", text: $name)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                            )
                    }
                    VStack(alignment: .leading){
                        Text("Description")
                            .font(.footnote)
                        TextEditor(text: $description)
                            .frame(height: 150)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                            )
                    }
                    
                    VStack{
                        DatePicker(
                            "Start Date",
                            selection: $tripStartDate,
                        )
                        DatePicker(
                            "End Date",
                            selection: $tripEndDate,
                        )
                        
                    }
                    
                    Button(action: {
                        isSubmitLoading = true
                        defer {isSubmitLoading = false}
                        guard let user = authStore.user else {
                            return
                        }
                        Task {
                            let result = await tripStore.createTrip(userId: user.id, username: user.username, name: name, description: description, created_at: dateFormatterService.supabaseDateString(tripStartDate), ended_at: dateFormatterService.supabaseDateString(tripEndDate))
                            if(result){
                                name = ""
                                description = ""
                                //go to add user page?
                                showCreateTripView = false
                            }
                        }
                        
                    }) {
                        Text("Create")
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
                    .disabled(name == "")
                    .disabled(isSubmitLoading)
                }
                .navigationTitle("New Trip")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showCreateTripView = false
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .padding()
            }
            
        }
        
    }
}
