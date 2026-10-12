//
//  ShareButton.swift
//  caravyn
//
//  Created by Ty Dickson on 10/8/26.
//



import SwiftUI
import UIKit
import CoreTransferable
import UniformTypeIdentifiers
import Supabase

struct ShareButton: View {
    let post: Post

    @State private var thumbnail: UIImage?
    @State private var localVideoURL: URL?
    @State private var isLoading = false

    private let retrievePostService = RetrievePostService()

    var body: some View {
        HStack {
            if post.media_type == "video" {
                if let localVideoURL, let thumbnail {
                    ShareLink(
                        item: ShareableVideo(url: localVideoURL),
                        preview: SharePreview(
                            "Caravyn Video",
                            image: Image(uiImage: thumbnail)
                        )
                    ) {
                        shareLabel
                    }
                } else if isLoading {
                    ProgressView()
                } else {
                    shareLabel
                        .foregroundStyle(.secondary)
                }
            } else {
                if let thumbnail {
                    ShareLink(
                        item: Image(uiImage: thumbnail),
                        preview: SharePreview(
                            "Caravyn Photo",
                            image: Image(uiImage: thumbnail)
                        )
                    ) {
                        shareLabel
                    }
                } else {
                    shareLabel
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            if thumbnail == nil, let path = post.media_url {
                thumbnail = await retrievePostService.getUIImage(path: path)
            }

            guard post.media_type == "video",
                  localVideoURL == nil else {
                return
            }

            isLoading = true
            defer { isLoading = false }

            guard let path = await retrievePostService.getVideoUpload(
                postId: post.id
            ),
            let remoteURL = makeVideoURL(path: path) else {
                print("Could not create video URL")
                return
            }

            do {
                let (temporaryURL, response) =
                    try await URLSession.shared.download(from: remoteURL)

                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print("Video download failed")
                    return
                }

                let fileExtension = remoteURL.pathExtension.isEmpty
                    ? "mov"
                    : remoteURL.pathExtension

                let destinationURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension(fileExtension)

                try FileManager.default.moveItem(
                    at: temporaryURL,
                    to: destinationURL
                )

                localVideoURL = destinationURL
            } catch {
                print("Video download error:", error)
            }
        }
    }

    // Converts the returned storage path into a full Supabase URL.
    private func makeVideoURL(path: String) -> URL? {
        let cleanPath = path.hasPrefix("post-media/")
            ? String(path.dropFirst("post-media/".count))
            : path

        do {
            return try SupabaseHandler.client.storage
                .from("post-media")
                .getPublicURL(path: cleanPath)
        } catch {
            print("Video URL error:", error)
            return nil
        }
    }

    private var shareLabel: some View {
        Image(systemName: "arrowshape.turn.up.right")
    }
}

