//
//  AppSuggestionElement.swift
//  caravyn
//
//  Created by Ty Dickson on 9/19/26.
//

import SwiftUI

struct AppSuggestionElement: View {
    
    var userId: String
    
    @State var suggestion: String = ""
    
    var appSuggestionService = AppSuggestionService()
    @State var serviceLoading: Bool = false
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading){
                Text("Suggestion")
                    .font(.footnote)
                TextEditor(text: $suggestion)
                    .frame(height: 100)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.dark.opacity(0.5), lineWidth: 2)
                    )
            }
            Button(action: {
                Task {
                    serviceLoading = true
                    let result = await appSuggestionService.addSuggestion(userId: userId, suggestion: suggestion)
                    if(result){
                        suggestion = ""
                    }
                    
                    serviceLoading = false
                    
                }
            }){
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .tint(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.dark)
                    .stroke(Color.dark.opacity(0.5), lineWidth: 2)
            )
            .disabled(suggestion.isEmpty)
            .disabled(serviceLoading)
        }
        .padding()
    }
}
