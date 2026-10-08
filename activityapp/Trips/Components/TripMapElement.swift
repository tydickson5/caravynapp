//
//  TripMapElement.swift
//  caravyn
//
//  Created by Ty Dickson on 9/29/26.
//

import SwiftUI
import _MapKit_SwiftUI
import MapKit

struct TripMapElement: View {
    
    @State private var position: MapCameraPosition = .automatic
    @State private var zoomLevel: Double = 112.60658752186015
    
    var posts: [Post]
    
    func getPostCoordAverage() {
        
        let coordinates = posts.compactMap { $0.coordinate }

        var rect = MKMapRect.null

        for coordinate in coordinates {
            let point = MKMapPoint(coordinate)
            let pointRect = MKMapRect(
                x: point.x,
                y: point.y,
                width: 0,
                height: 0
            )
        
            rect = rect.union(pointRect)
        }
        
        rect = rect.insetBy(
            dx: -rect.size.width * 0.15,
            dy: -rect.size.height * 0.15
        )

        position = .rect(rect)
    }
    
    var body: some View {
        Map(position: $position){
            ForEach(posts, id: \.id) { post in
                Annotation("", coordinate: post.coordinate!) {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundStyle(Color.pin)
                        .frame(width: 50, height: 50)
                }
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .task {
            getPostCoordAverage()
        }
    }
}
