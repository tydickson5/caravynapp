//
//  CountriesVisitedStore.swift
//  caravyn
//
//  Created by Ty Dickson on 11/11/26.
//

import Foundation
internal import Combine
import Supabase

final class CountriesVisitedStore: ObservableObject {
    
    @Published var countries: [Country] = []
    @Published var visitedCountries: [VisitedCountry] = []
        
    func loadUserCountries(userId: String) async {
        
        countries = CountriesService.loadCountries()
        
        do {
            let fetched: [VisitedCountry] = try await SupabaseHandler.client
                .from("user_visited_countries")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value

            visitedCountries = fetched
            
            
        } catch {
            
        }
        
    }
    
    func loadOtherUserCountries(userId: String) async -> [VisitedCountry] {
        
        do {
            let fetched: [VisitedCountry] = try await SupabaseHandler.client
                .from("user_visited_countries")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value

            return fetched
        } catch {
            return []
        }
    }
    
    func addVisitedCountry(countryId: String, userId: String, countryName: String) async -> Bool {
        do {
            try await SupabaseHandler.client.from("user_visited_countries")
                .insert([
                    "id": countryId,
                    "user_id": userId,
                    "name": countryName
                ]).execute()
            
            await loadUserCountries(userId: userId)
            
            return true
                
        } catch {
            print(error)
            ToastManager.shared.error("Error adding country")
            return false
        }
    }
    
    func removeVisitedCountry(userId: String, countryName: String) async -> Bool {
        
        do {
            try await SupabaseHandler.client.from("user_visited_countries").delete().eq("user_id", value: userId).eq("name", value: countryName).execute()
            
            await loadUserCountries(userId: userId)
            return true
        } catch {
            print(error)
            ToastManager.shared.error("Error removing Country")
            return false
        }
    }
    
}
