//
//  TripService.swift
//  caravyn
//
//  Created by Ty Dickson on 8/23/26.
//

import Foundation
import Supabase

struct TripService {
    
    func startTrip(userId: String, username: String, name: String, description: String, backendService: BackendService) async -> Trip? {
        
        let body: [String: Any] = [
            "userId": userId,
            "username": username,
            "name": name,
            "description": description
        ]
        
        do {
            
            guard let request = try await backendService.loadHttpRequest(path: "trips/start", body: body) else {
                ToastManager.shared.error("Error starting trip")
                return nil
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            print(response)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                
                throw NSError(domain: "startTrip", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            let newTrip = try JSONDecoder().decode(Trip.self, from: data)
            
            ToastManager.shared.success("Trip started")
            return newTrip
            
        } catch {
            ToastManager.shared.error("Error starting trip")
            return nil
        }
    }
    
    func createTrip(userId: String, username: String, name: String, description: String, created_at: String, ended_at: String, backendService: BackendService) async -> Trip? {
        
        let body: [String: Any] = [
            "userId": userId,
            "username": username,
            "name": name,
            "description": description,
            "created_at": created_at,
            "ended_at": ended_at
        ]
        
        do {
            
            guard let request = try await backendService.loadHttpRequest(path: "trips/create", body: body) else {
                ToastManager.shared.error("Error starting trip")
                return nil
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            print(response)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                
                throw NSError(domain: "startTrip", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            let newTrip = try JSONDecoder().decode(Trip.self, from: data)
            
            print(newTrip)
            
            ToastManager.shared.success("Trip created")
            return newTrip
            
        } catch {
            ToastManager.shared.error("Error creating trip")
            return nil
        }
    }
    
    func endTrip(tripId: String, backendService: BackendService) async -> Bool {
        
        let body: [String: Any] = [
            "tripId": tripId
        ]
        
        do {
            
            guard let request = try await backendService.loadHttpRequest(path: "trips/end", body: body) else {
                ToastManager.shared.error("Error starting trip")
                return false
            }
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw NSError(domain: "startTrip", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            ToastManager.shared.success("Trip ended")
            return true
            
        } catch {
            ToastManager.shared.error("Error ending trip")
            return false
        }
        
    }
    
    func updateTripDetails(tripId: String, name: String, description: String, created_at: String, ended_at: String, backendService: BackendService) async -> Bool {
        
        let body: [String: Any] = [
            "tripId": tripId,
            "name": name,
            "description": description,
            "created_at": created_at,
            "ended_at": ended_at
        ]
        
        do {
            guard let request = try await backendService.loadHttpRequest(path: "trips/update", body: body) else {
                ToastManager.shared.error("Error updating trip")
                return false
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                
                throw NSError(domain: "updateTrip", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            _ = try JSONDecoder().decode(Trip.self, from: data)
            
            ToastManager.shared.success("Updated")
            return true
        } catch {
            ToastManager.shared.error("Error updating trip")
            return false
        }
    }
    
    func addUserToTrip(tripId: String, userId: String, backendService: BackendService) async -> Bool {
        let body: [String: Any] = [
            "tripId": tripId,
            "userId": userId
        ]
        
        do {
            guard let request = try await backendService.loadHttpRequest(path: "trips/addUser", body: body) else {
                ToastManager.shared.error("Error adding user")
                return false
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                print("addUser failed:", (response as? HTTPURLResponse)?.statusCode ?? -1,
                      String(data: data, encoding: .utf8) ?? "")
                throw NSError(domain: "addUserToTrip", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            ToastManager.shared.success("Added")
            return true
            
        } catch {
            print(error)
            ToastManager.shared.error("Error adding user")
            return false
        }
    }

    func removeUserFromTrip(tripId: String, userId: String, backendService: BackendService) async -> Bool {
        let body: [String: Any] = [
            "tripId": tripId,
            "userId": userId
        ]
        
        do {
            guard let request = try await backendService.loadHttpRequest(path: "trips/removeUser", body: body) else {
                ToastManager.shared.error("Error leaving trip")
                return false
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                print("removeUser failed:", (response as? HTTPURLResponse)?.statusCode ?? -1,
                      String(data: data, encoding: .utf8) ?? "")
                throw NSError(domain: "removeUserFromTrip", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            ToastManager.shared.success("You have left")
            return true
            
        } catch {
            print(error)
            ToastManager.shared.error("Error leaving trip")
            return false
        }
    }
    
    func getTripById(tripId: String) async -> Trip? {
        
        do {
            let fetched: Trip = try await SupabaseHandler.client.from("trips").select().eq("id", value: tripId).single().execute().value
            return fetched
        } catch {
            print(error)
            return nil
        }
    }
    
    func getUsersTrips(userId: String) async -> [Trip]? {
        do {
            let userTrips = await getUserTrips(userId: userId)

            guard let userTrips, !userTrips.isEmpty else {
                return []
            }

            let tripIds = userTrips.map { $0.trip_id }

            let fetched: [Trip] = try await SupabaseHandler.client
                .from("trips")
                .select()
                .in("id", values: tripIds)
                .order("created_at", ascending: false)
                .execute()
                .value

            return fetched
        } catch {
            print("Error fetching user trips:", error)
            return nil
        }
    }
    
    func getUserTrips(userId: String) async -> [UserTrip]? {
        do {
            let fetched: [UserTrip] = try await SupabaseHandler.client.from("trip_friend").select().eq("user_id", value: userId).order("created_at", ascending: false).execute().value
            return fetched
        } catch {
            print(error)
            return nil
        }
    }
    
    func getUsersInTrip(tripId: String) async -> [AppUser] {
        do {
            let fetchedUserTrips: [UserTrip] = try await SupabaseHandler.client.from("trip_friend").select().eq("trip_id", value: tripId).order("created_at", ascending: false).execute().value
            
            guard !fetchedUserTrips.isEmpty else {
                return []
            }

            let userIds = fetchedUserTrips.map { $0.user_id }
            
            let fetchedUsers: [AppUser] = try await SupabaseHandler.client.from("profiles").select().in("id", values: userIds).order("created_at", ascending: false)
                .execute()
                .value
            
            return fetchedUsers
        } catch {
            print(error)
            return []
        }
    }
    
    func getOtherUsersPostsInTrip(tripId: String) async -> [Post] {
        do {
            let otherMembers = await getUsersInTrip(tripId: tripId)
            
            guard !otherMembers.isEmpty else {
                return []
            }

            let userIds = otherMembers.map { $0.id }
            print(userIds)
            
            let fetchedPosts: [Post] = try await SupabaseHandler.client.from("posts").select().in("user_id", values: userIds).order("created_at", ascending: true).execute().value
            
            print(fetchedPosts.count)
            
            return fetchedPosts
            
        } catch {
            print(error)
            return []
        }
    }
}
