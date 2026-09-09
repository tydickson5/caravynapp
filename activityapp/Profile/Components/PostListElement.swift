//
//  PostView.swift
//  caravyn
//
//  Created by Ty Dickson on 8/31/26.
//

import SwiftUI
import NukeUI

enum FeedItem: Identifiable {
    case trip(Trip)
    case postPair([Post])

    var id: String {
        switch self {
        case .trip(let t): return "trip-\(t.id)"
        case .postPair(let p):
            return "posts-\(p.map(\.id).joined(separator: "-"))"
        }
    }
}

struct PostListElement: View {

    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var postStore: PostStore
    var retrievePostService = RetrievePostService()

    @State private var trips: [Trip] = []
    @State private var feedItems: [FeedItem] = []
    @Binding var posts: [Post]

    private let tripService = TripService()
    
    @State var tripToShow: Trip? = nil

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    func buildFeed() {
        var items: [FeedItem] = []
        var pIndex = 0
        var tIndex = 0

        while pIndex < posts.count || tIndex < trips.count {
            let nextTrip = tIndex < trips.count ? trips[tIndex] : nil
            let nextPost = pIndex < posts.count ? posts[pIndex] : nil

            if let trip = nextTrip,
               nextPost == nil || trip.created_at < nextPost!.created_at {
                items.append(.trip(trip))
                tIndex += 1
            } else if let post = nextPost {
                // Only pair with the next post if no trip starts before it —
                // otherwise the pair would straddle a trip boundary.
                var pair = [post]
                var next = pIndex + 1

                if next < posts.count {
                    let candidate = posts[next]
                    let tripStartsBeforeCandidate = nextTrip.map { $0.created_at < candidate.created_at } ?? false

                    if !tripStartsBeforeCandidate {
                        pair.append(candidate)
                        next += 1
                    }
                }

                items.append(.postPair(pair))
                pIndex = next
            }
        }

        feedItems = items
    }

    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(feedItems) { item in
                switch item {
                case .trip(let trip):
                    Text("")
                    /*
                    Text(trip.name)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .onTapGesture {
                            tripToShow = trip
                        }
                    */
                case .postPair(let pair):
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(pair) { post in
                            NavigationLink(destination: PostDetailView(post: post), label: {
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
                                //.border(.red)

                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            })
                            //.border(.green)
                            
                        }
                    }
                    //.border(.blue)
                }
            }
        }
        .task {
            if let userId = authStore.user?.id {
                trips = await tripService.getUsersTrips(userId: userId)
            }
            buildFeed()
        }
        .onChange(of: posts) { _, _ in
            buildFeed()
        }
        .sheet(item: $tripToShow) { trip in
            EditTripView(trip: trip, ended: trip.ended_at == nil ? true : false)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .task {
                        print("PostList width:", geo.size.width)
                    }
            }
        )
    }
}
