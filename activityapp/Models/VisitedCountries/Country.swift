//
//  CountryVisited.swift
//  caravyn
//
//  Created by Ty Dickson on 11/11/26.
//
import CoreLocation

struct Country: Identifiable {
    let id: String
    let name: String
    let alpha2Code: String
    let alpha3Code: String
    let polygons: [[CLLocationCoordinate2D]]
}
