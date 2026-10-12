//
//  TripCard.swift
//  caravyn
//
//  Created by Ty Dickson on 10/1/26.
//

import SwiftUI
import NukeUI

struct TripCard: View {
    
    var trip: Trip
    var posts: [Post]
    
    var retrievePostService = RetrievePostService()
    
    private var topPost: [Post] {
        posts.sorted{ $0.post_likes > $1.post_likes}.prefix(1).map{$0}
    }
    
    var body: some View {

        ZStack(alignment: .topLeading) {
            if let post = topPost.first {
                if let media = post.media_url, !media.isEmpty,
                   let url = retrievePostService.imageURL(path: media) {
                    LazyImage(url: url) { state in
                        if let image = state.image {
                            image.resizable()
                                .scaledToFill()
                        } else {
                            Color.gray.opacity(0.2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trip.name)
                    .font(.title2)
                    .foregroundStyle(.white)
                TripDatesElement(startDate: trip.created_at, endDate: trip.ended_at)
            }
            .padding(10)
            .background(Color.black.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(12)
        }
        .frame(height: 200)
    }
    
}
