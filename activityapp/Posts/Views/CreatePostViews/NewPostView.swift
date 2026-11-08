//
//  NewPostView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/3/26.
//

import SwiftUI

struct NewPostView: View {
    
    @State var showCamera = false
    
    @State private var showLocationAlert = false
    
    @State private var capturedMedia: CameraResult?
    @StateObject private var postHandler = PostsHandler()
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var locationHandler: LocationHandler
    
    var body: some View{
        VStack {
            HStack{
                Spacer()
                
                Button(action:{
                    showCamera.toggle()
                }){
                    Text("Open camera")
                        .padding(.trailing, 5)
                        .foregroundStyle(Color.lightBlue)
                    Image(systemName: "camera.fill")
                        .foregroundStyle(Color.lightBlue)
                        .imageScale(.large)
                }
                .padding(.bottom, 10)
            }
            if let media = capturedMedia, let authUser = authStore.user{
                PostPreviewElement(
                    media: media,
                    userId: authUser.id,
                    groupId: "6ce9c8f8-2ff2-4f12-8f74-19671fcfb265"/* current group id */,
                    latitude: locationHandler.latitude,
                    longitude: locationHandler.longitude/* current long */
                    
                ) {
                    capturedMedia = nil
                    // navigate away / dismiss, etc.
                }
            } else {
                Spacer()
            }
        }
        .padding()
        .background(Color.background)
        .sheet(isPresented: $showCamera) {
            NewCameraView { result in
                capturedMedia = result
            }
        }
        .alert("Location Required", isPresented: $showLocationAlert) {
            Button {
                locationHandler.openSettings()
            } label: {
                Text("Open Settings")
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(10)
            }
            Button("Cancel") {
                showLocationAlert = false
            }
            .tint(.secondary)
        } message: {
            Text("Caravyn needs location access to associate your posts with the places you've visited. Please enable location access in Settings.")
        }
        .onAppear {
            if locationHandler.isAuthorized {
                locationHandler.recenter()
                showCamera = true
            } else if locationHandler.authorizationStatus == .denied {
                showLocationAlert = true
            } else {
                locationHandler.requestPermission()

                ToastManager.shared.error(
                    "You need location permissions on to be able to post"
                )
            }
        }
        .onDisappear {
            locationHandler.stopTracking()
        }
    }
}
