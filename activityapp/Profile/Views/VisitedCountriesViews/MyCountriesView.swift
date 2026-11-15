//
//  MyCountriesView.swift
//  caravyn
//
//  Created by Ty Dickson on 11/12/26.
//


import SwiftUI

struct MyCountriesView: View {

    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var countriesVisitedStore: CountriesVisitedStore

    @State private var searchText = ""
    
    @State private var isLoading = false

    // MARK: - Filter and Sort Countries

    private var displayedCountries: [Country] {

        let visitedIDs = Set(
            countriesVisitedStore.visitedCountries.map {
                $0.id
            }
        )

        return countriesVisitedStore.countries
            .filter {
                searchText.isEmpty ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { first, second in

                let firstVisited = visitedIDs.contains(first.id)
                let secondVisited = visitedIDs.contains(second.id)

                // Visited countries first
                if firstVisited != secondVisited {
                    return firstVisited
                }

                // Alphabetical within each group
                return first.name.localizedCaseInsensitiveCompare(
                    second.name
                ) == .orderedAscending
            }
    }


    var body: some View {
        ZStack {
            // Your existing view
            List(displayedCountries) { country in
                
                HStack {
                    Text(country.name)

                    Spacer()

                    if countriesVisitedStore.visitedCountries.contains(
                        where: { $0.id == country.id }
                    ) {
                        Text("added").font(.caption)
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.dark)
                            .onTapGesture {
                                Task{
                                    if let user = authStore.user{
                                        isLoading = true
                                        _ = await countriesVisitedStore.removeVisitedCountry(userId: user.id, countryName: country.name)
                                        isLoading = false
                                    }
                                }
                                
                            }
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.green)
                            .onTapGesture {
                                Task{
                                    if let user = authStore.user{
                                        isLoading = true
                                        _ = await countriesVisitedStore.addVisitedCountry(countryId: country.id, userId: user.id, countryName: country.name)
                                        isLoading = false
                                    }
                                }
                                
                            }
                    }
                }
            }
            .navigationTitle("Your Countries")
            .searchable(
                text: $searchText,
                prompt: "Search countries"
            )
            .scrollContentBackground(.hidden)
            .background(Color.background)
            if isLoading {
                ProgressView()
                    .tint(.dark)
                    .scaleEffect(1.5)
            }
        }
        
    }
}
