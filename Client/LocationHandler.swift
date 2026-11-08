
import CoreLocation
import SwiftUI
internal import Combine
import UIKit

@MainActor
final class LocationHandler: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    var latitude: Double {
        location?.coordinate.latitude ?? 0.0
    }

    var longitude: Double {
        location?.coordinate.longitude ?? 0.0
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse ||
        authorizationStatus == .authorizedAlways
    }

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        authorizationStatus = manager.authorizationStatus
    }

    func requestPermission() {
        print("REQUESTING LOCATION PERMISSION")
        print("Current status: \(manager.authorizationStatus.rawValue)")

        switch manager.authorizationStatus {
        case .notDetermined:
            print("Status not determined - requesting permission")
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            print("Already authorized")
            manager.startUpdatingLocation()

        case .denied:
            print("Permission denied - must open Settings")

        case .restricted:
            print("Permission restricted")

        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(url)
    }

    func recenter() {
        guard isAuthorized else {
            requestPermission()
            return
        }

        manager.startUpdatingLocation()
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()

        case .denied, .restricted:
            manager.stopUpdatingLocation()

        case .notDetermined:
            break

        @unknown default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let latest = locations.last,
              latest.horizontalAccuracy >= 0,
              latest.horizontalAccuracy < 100 else {
            return
        }

        location = latest
        manager.stopUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error: \(error.localizedDescription)")
    }
}
