//
//  PostMapElement.swift
//  caravyn
//
//  Created by Ty Dickson on 11/21/26.
//

import SwiftUI
import MapKit

struct PostMapElement: View {

    var post: Post

    private var coordinate: CLLocationCoordinate2D? {
        guard let latitude = post.latitude,
              let longitude = post.longitude else {
            return nil
        }

        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }

    var body: some View {
        if let coordinate {
            Map(position: .constant(.region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            ))) {
                Annotation("", coordinate: coordinate) {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundStyle(Color.pin)
                        .frame(width: 50, height: 50)
                }
            }
            .frame(height: 200)
            .cornerRadius(16)
        } else {
            ContentUnavailableView(
                "No Location",
                systemImage: "map"
            )
        }
    }
}
