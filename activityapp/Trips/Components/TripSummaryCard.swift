//
//  TripSummaryCard.swift
//  caravyn
//
//  Created by Ty Dickson on 9/12/26.
//

import SwiftUI
import NukeUI

struct TripSummaryCard: View {

    var trip: Trip
    var posts: [Post]

    var retrievePostService = RetrievePostService()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var topPosts: [Post] {
        posts
            .sorted { $0.post_likes > $1.post_likes }
            .prefix(4)
            .map { $0 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(trip.name)
                    .font(.headline)
                if !trip.description.isEmpty {
                    Text(trip.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            if !topPosts.isEmpty {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(topPosts) { post in
                        thumbnail(for: post)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private func thumbnail(for post: Post) -> some View {
        GeometryReader { geo in
            if let media = post.media_url, !media.isEmpty,
               let url = retrievePostService.imageURL(path: media) {
                LazyImage(url: url) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.width)
                .clipped()
            } else {
                Color.gray.opacity(0.15)
                    .frame(width: geo.size.width, height: geo.size.width)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
