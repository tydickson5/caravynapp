//
//  TermsOfServiceCheckBox.swift
//  caravyn
//
//  Created by Ty Dickson on 10/20/26.
//

import SwiftUI

struct TermsOfServiceCheckBox: View {
    
    @Binding var checkedTermsOfService: Bool
        
    // Replace with your live legal URL
    private let termsURL = URL(string: "https://caravyn.com/terms")!
    
    var body: some View {
        Toggle(isOn: $checkedTermsOfService) {
            HStack(spacing: 4) {
                Text("I agree to the")

                Link("Terms of Service", destination: termsURL)
                    .underline()
            }
                .font(.footnote)
        }
        .toggleStyle(.switch) // or default switch style
    }
}
