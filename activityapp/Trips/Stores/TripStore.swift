//
//  TripStore.swift
//  caravyn
//
//  Created by Ty Dickson on 11/23/26.
//

internal import Combine
import Foundation

@MainActor
class TripStore: ObservableObject {
    
    
    @Published var trips: [Trip] = []
    
    @Published var isLoading = false
    
    private let tripService = TripService()
    private let backendService = BackendService()
    
    func loadTrips(userId: String) async {
        isLoading = true
        defer {isLoading = false}
            
        if let fetchedTrips = await tripService.getUsersTrips(userId: userId) {
            trips = fetchedTrips
        }
    }
    
    func startTrip(userId: String, username: String, name: String, description: String) async -> Bool {
        isLoading = true
        defer{isLoading = false}
        
        if let newTrip = await tripService.startTrip(userId: userId, username: username, name: name, description: description, backendService: backendService) {
            trips.append(newTrip)
            return true
        }
        
        return false
    }
    
    func createTrip(userId: String, username: String, name: String, description: String, created_at: String, ended_at: String) async -> Bool {
        isLoading = true
        defer{isLoading = false}
        
        if let newTrip = await tripService.createTrip(userId: userId, username: username, name: name, description: description, created_at: created_at, ended_at: ended_at, backendService: backendService) {
            trips.append(newTrip)
            print(newTrip)
            return true
        }
        return false
    }
    
    func endTrip(tripId: String, userId: String) async {
        isLoading = true
        defer{isLoading = false}
        
        let response = await tripService.endTrip(tripId: tripId, backendService: backendService)
        
        if (response) {
            await loadTrips(userId: userId)
        }
    }
    
    func updateTripDetails(userId: String ,tripId: String, name: String, description: String, created_at: String, ended_at: String) async -> Bool{
        isLoading = true
        defer{isLoading = false}
        
        let response = await tripService.updateTripDetails(tripId: tripId, name: name, description: description, created_at: created_at, ended_at: ended_at, backendService: backendService)
        
        if(response){
            await loadTrips(userId: userId)
            return true
        }
        
        return false
    }
    
    func addUserToTrip(tripId: String, userId: String) async {
        isLoading = true
        defer{isLoading = false}
        
        _ = await tripService.addUserToTrip(tripId: tripId, userId: userId, backendService: backendService)
        
        
    }
    
    func removeUserFromTrip(tripId: String, userId: String) async {
        
        isLoading = true
        defer{isLoading = false}
        
        _ = await tripService.removeUserFromTrip(tripId: tripId, userId: userId, backendService: backendService)
    }
    
    func getTripById(tripId: String) async -> Trip? {
        if let trip = await tripService.getTripById(tripId: tripId){
            return trip
        }
        return nil
    }
    
    func getUsersInTrip(tripId: String) async -> [AppUser] {
        return await tripService.getUsersInTrip(tripId: tripId)
    }
    
    func getOtherUsersPostsInTrip(tripId: String) async -> [Post] {
        return await tripService.getOtherUsersPostsInTrip(tripId: tripId)
    }
    
}
