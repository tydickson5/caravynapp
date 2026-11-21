//
//  MapView.swift
//  caravyn
//
//  Created by Ty Dickson on 11/12/26.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    //@EnvironmentObject var countriesVisitedStore: CountriesVisitedStore
    
    var other: Bool
    
    var countries: [Country]
    var visitedCountries: [VisitedCountry]

    // Match visited country names to the full Country objects
    private var visitedCountriesForMap: [Country] {
        let visitedNames = Set(
            visitedCountries.map {
                $0.name.lowercased()
            }
        )

        return countries.filter {
            visitedNames.contains($0.name.lowercased())
        }
    }
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 160, longitudeDelta: 360)
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(visitedCountriesForMap) { country in

                // A country can have multiple polygons
                ForEach(
                    Array(country.polygons.enumerated()),
                    id: \.offset
                ) { _, coordinates in

                    MapPolygon(coordinates: coordinates)
                        .foregroundStyle(.lightBlue.opacity(0.35))
                        .stroke(.lightBlue, lineWidth: 2)
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing){
            if !other {
                NavigationLink {
                    MyCountriesView()
                } label: {
                    Image(systemName: "plus")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                    
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            
        }
    }
}
