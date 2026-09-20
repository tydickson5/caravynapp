//
//  UserLimitCalculator.swift
//  caravyn
//
//  Created by Ty Dickson on 9/19/26.
//
import Supabase
import SwiftUI
public import Combine

@MainActor
final class UserLimitCalculator: ObservableObject {

    @Published var isLoading = true
    @Published var numberOfUsers = 0

    func getNumberOfAppUsers() async {

        do {
            let response = try await SupabaseHandler.client
                .from("profiles")
                .select("*", head: true, count: .exact)
                .execute()

            numberOfUsers = response.count ?? 0
            print(numberOfUsers)
        } catch {
            print(error)
        }

        isLoading = false
    }
}
