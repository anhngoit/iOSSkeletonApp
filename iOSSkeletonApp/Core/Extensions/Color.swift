//
//  Color.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI

extension Color {
    static var lightPurpleColor: Color = Color("LightPurple")
    static var primaryTextColor: Color = Color(hex: "#FFFFFF")
}

extension Color {
    // Initialize a Color from Hex Code
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        if hex.hasPrefix("#") { scanner.currentIndex = hex.index(after: hex.startIndex) }
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        let alpha = hex.count == 9 ? Double((rgb & 0xFF)) / 255.0 : 1.0

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
