//
//  PostView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/31/26.
//

import SwiftUI
import NukeUI

struct PostListElement: View {

    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var postStore: PostStore
    var retrievePostService = RetrievePostService()

    @Binding var posts: [Post]
    var trip: Trip?

    @State private var postPairs: [[Post]] = []

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    func buildFeed() {
        let start = trip!.created_at
        let end = trip?.ended_at ?? ""

        let tripPosts = posts
            .filter { $0.created_at >= start && $0.created_at <= end }
            .sorted { $0.created_at > $1.created_at }  // newest first

        var pairs: [[Post]] = []
        var i = 0
        while i < tripPosts.count {
            if i + 1 < tripPosts.count {
                pairs.append([tripPosts[i], tripPosts[i + 1]])
                i += 2
            } else {
                pairs.append([tripPosts[i]])
                i += 1
            }
        }

        postPairs = pairs
    }
    
    func buildFeedWithoutTrip() {

        var pairs: [[Post]] = []
        var i = 0
        while i < posts.count {
            if i + 1 < posts.count {
                pairs.append([posts[i], posts[i + 1]])
                i += 2
            } else {
                pairs.append([posts[i]])
                i += 1
            }
        }

        postPairs = pairs
    }

    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(postPairs, id: \.self) { pair in
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(pair) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            VStack(alignment: .leading) {
                                if let media = post.media_url, !media.isEmpty {
                                    GeometryReader { geo in
                                        LazyImage(url: retrievePostService.imageURL(path: media)) { state in
                                            if let image = state.image {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } else {
                                                Color.gray.opacity(0.2)
                                            }
                                        }
                                        .frame(width: geo.size.width, height: 300)
                                        .clipped()
                                    }
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        }
                    }
                }
            }
        }
        .task {
            if trip != nil {
                buildFeed()
            }
            else {
                buildFeedWithoutTrip()
            }
            
        }
        .onChange(of: posts) { _, _ in
            if trip != nil {
                buildFeed()
            }
            else {
                buildFeedWithoutTrip()
            }
        }
    }
}
