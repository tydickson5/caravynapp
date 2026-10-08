//
//  FontSettings.swift
//  caravyn
//
//  Created by Ty Dickson on 9/29/26.
//

import SwiftUI

extension Font {
    // 1. Override the standard semantic styles
    public static let largeTitle = Font.custom("EBGaramond", size: 34, relativeTo: .largeTitle)
    public static let title = Font.custom("EBGaramond", size: 28, relativeTo: .title)
    public static let title2 = Font.custom("EBGaramond", size: 22, relativeTo: .title2)
    public static let title3 = Font.custom("EBGaramond", size: 20, relativeTo: .title3)
    public static let headline = Font.custom("EBGaramond", size: 17, relativeTo: .headline)
    public static let subheadline = Font.custom("EBGaramond", size: 15, relativeTo: .subheadline)
    public static let body = Font.custom("EBGaramond", size: 17, relativeTo: .body)
    public static let callout = Font.custom("EBGaramond", size: 16, relativeTo: .callout)
    public static let footnote = Font.custom("EBGaramond", size: 13, relativeTo: .footnote)
    public static let caption = Font.custom("EBGaramond", size: 12, relativeTo: .caption)
    public static let caption2 = Font.custom("EBGaramond", size: 11, relativeTo: .caption2)
    
    // 2. Intercept .system(size:) calls used in code
    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        return Font.custom("EBGaramond", size: size)
    }
    
    // 3. Intercept .system(_:design:weight:) style allocations
    public static func system(_ style: Font.TextStyle, design: Font.Design = .default, weight: Font.Weight = .regular) -> Font {
        let baseSize: CGFloat
        switch style {
        case .largeTitle: baseSize = 34
        case .title: baseSize = 28
        case .title2: baseSize = 22
        case .title3: baseSize = 20
        case .headline, .body: baseSize = 17
        case .subheadline, .callout: baseSize = 15
        case .footnote: baseSize = 13
        case .caption: baseSize = 12
        case .caption2: baseSize = 11
        @unknown default: baseSize = 17
        }
        
        return Font.custom("EBGaramond", size: baseSize, relativeTo: style)
    }
}
