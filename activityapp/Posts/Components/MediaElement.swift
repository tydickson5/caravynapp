//
//  MediaElement.swift
//  caravyn
//
//  Created by Ty Dickson on 8/20/26.
//

import SwiftUI
import AVFoundation
import NukeUI
import _AVKit_SwiftUI

struct MediaElement: View {
    
    @Binding var post: Post
    
    @State var userId: String
    
    @EnvironmentObject var postStore: PostStore
    var retrievePostService = RetrievePostService()
    
    @State private var player: AVPlayer?
    @State private var videoURL: URL?
    
    var body: some View {
        HStack {
            if(post.media_type == "image") {
                LazyImage(url: retrievePostService.imageURL(path: post.media_url!)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 12
                                )
                            )
                    } else {
                        ProgressView()
                    }
                }
            } else {
                if let player {
                    VideoPlayer(player: player)
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                } else {
                    if let thumbnailPath = post.media_url, let thumbnailURL = retrievePostService.imageURL(path: thumbnailPath) {
                        LazyImage(url: thumbnailURL) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 12
                                        )
                                    )
                            } else {
                                ProgressView()
                            }
                        }
                    }
                }
                
            }
        }

        .overlay(alignment: .topTrailing) {
            if(userId == post.user_id){
                Button {
                    saveMedia()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(10)
            }
            
        }
        .task(id: post.id){
            guard post.media_type == "video" else { return }

            if let videoPath = await retrievePostService.getVideoUpload(postId: post.id),
               let url = retrievePostService.imageURL(path: videoPath) {
                videoURL = url   // cache for save button
                player = AVPlayer(url: url)
                player?.play()
            }
        }

        .onDisappear {
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    private func saveMedia() {
        if post.media_type == "image" {
            guard let path = post.media_url,
                  let url = retrievePostService.imageURL(path: path) else { return }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data, let image = UIImage(data: data) else { return }
                PhotoLibrarySaver.save(image: image)
            }.resume()

        } else {
            guard let videoURL else { return }

            URLSession.shared.downloadTask(with: videoURL) { tempURL, _, _ in
                guard let tempURL else { return }
                let destURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString + ".mp4")
                try? FileManager.default.moveItem(at: tempURL, to: destURL)
                PhotoLibrarySaver.save(videoURL: destURL) { _, _ in
                    try? FileManager.default.removeItem(at: destURL)
                }
            }.resume()
        }
    }
}
