//
//  AppEntryPoint.swift
//  AppEntryPoint
//
//  Created by Anh “Steven” Ngo on 17/6/25.
//

import SwiftUI

@main
struct AppEntryPoint: App {
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(networkMonitor)
        }
    }
}
