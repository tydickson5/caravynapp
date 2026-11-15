//
//  MyCountriesMapComponent.swift
//  caravyn
//
//  Created by Ty Dickson on 11/11/26.
//


import SwiftUI
import MapKit

struct MyCountriesMapComponent: View {

    @EnvironmentObject var countriesVisitedStore: CountriesVisitedStore

    // Match visited country names to the full Country objects
    private var visitedCountriesForMap: [Country] {
        let visitedNames = Set(
            countriesVisitedStore.visitedCountries.map {
                $0.name.lowercased()
            }
        )

        return countriesVisitedStore.countries.filter {
            visitedNames.contains($0.name.lowercased())
        }
    }
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: 15,
                longitude: 0
            ),
            distance: 50_000_000,
            heading: 0,
            pitch: 0
        )
    )


    var body: some View {
        NavigationStack{
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
            .frame(height: 200)
            .cornerRadius(16)
            .overlay(alignment: .bottomTrailing) {
                HStack() {
     
                    

                    NavigationLink {
                        MapView()
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        HStack{
                            Text("Your Countries")
                            Image(systemName: "chevron.right")
                                //.foregroundStyle()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                    }
                    NavigationLink {
                        MyCountriesView()
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
        
    }
}
