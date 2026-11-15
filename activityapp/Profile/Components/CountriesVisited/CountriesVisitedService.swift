
import Foundation
import MapKit
import CoreLocation

final class CountriesService {

    static func loadCountries() -> [Country] {

        // MARK: - Locate GeoJSON File

        print("BUNDLE PATH:", Bundle.main.bundlePath)

        let rootURL = Bundle.main.url(
            forResource: "countries",
            withExtension: "geojson"
        )

        let dataURL = Bundle.main.url(
            forResource: "countries",
            withExtension: "geojson",
            subdirectory: "Data"
        )

        print("ROOT URL:", rootURL as Any)
        print("DATA URL:", dataURL as Any)

        guard let url = dataURL ?? rootURL else {
            print("FAILED: countries.geojson not found in bundle")

            let resources = Bundle.main.urls(
                forResourcesWithExtension: "geojson",
                subdirectory: nil
            ) ?? []

            print("AVAILABLE GEOJSON FILES:", resources)

            return []
        }

        print("FOUND FILE:", url.path)

        // MARK: - Read File

        guard let data = try? Data(contentsOf: url) else {
            print("FAILED: Could not read GeoJSON file")
            return []
        }

        print("FILE SIZE:", data.count)

        // MARK: - Parse JSON

        guard let json = try? JSONSerialization.jsonObject(
            with: data
        ) as? [String: Any] else {
            print("FAILED: Could not parse JSON")
            return []
        }

        guard let features = json["features"] as? [[String: Any]] else {
            print("FAILED: GeoJSON has no features")
            return []
        }

        print("FEATURE COUNT:", features.count)

        // MARK: - Parse Countries

        var countries: [Country] = []

        for feature in features {

            guard
                let properties = feature["properties"] as? [String: Any],
                let name = properties["name"] as? String,
                let alpha2 = properties["ISO3166-1-Alpha-2"] as? String,
                let alpha3 = properties["ISO3166-1-Alpha-3"] as? String,
                alpha2 != "-99",
                alpha3 != "-99",
                let geometry = feature["geometry"] as? [String: Any],
                let type = geometry["type"] as? String,
                let coordinates = geometry["coordinates"]
            else {
                continue
            }

            var polygons: [[CLLocationCoordinate2D]] = []

            // Polygon
            if type == "Polygon",
               let rings = coordinates as? [[[Double]]] {

                if let outerRing = rings.first {

                    polygons.append(
                        outerRing.map {
                            CLLocationCoordinate2D(
                                latitude: $0[1],
                                longitude: $0[0]
                            )
                        }
                    )
                }
            }

            // MultiPolygon
            else if type == "MultiPolygon",
                    let multiPolygon = coordinates as? [[[[Double]]]] {

                for polygon in multiPolygon {

                    guard let outerRing = polygon.first else {
                        continue
                    }

                    polygons.append(
                        outerRing.map {
                            CLLocationCoordinate2D(
                                latitude: $0[1],
                                longitude: $0[0]
                            )
                        }
                    )
                }
            }

            else {
                continue
            }

            let country = Country(
                id: alpha2,
                name: name,
                alpha2Code: alpha2,
                alpha3Code: alpha3,
                polygons: polygons
            )

            countries.append(country)
        }

        print("SUCCESSFULLY LOADED COUNTRIES:", countries.count)

        return countries
    }
}
