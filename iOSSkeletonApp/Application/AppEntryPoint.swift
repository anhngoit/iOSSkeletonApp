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

    /// Unit tests run inside this app as their host, so without a guard the
    /// real UI appears and fires a live API request on every test launch.
    private var isRunningUnitTests: Bool {
        NSClassFromString("XCTestCase") != nil
    }

    init() {
        // Surfaces missing tokens/endpoints at launch instead of as a
        // mysterious 401 on the first request.
        Environment.validate()
    }

    var body: some Scene {
        WindowGroup {
            if isRunningUnitTests {
                EmptyView()
            } else {
                MainTabView()
                    .environmentObject(networkMonitor)
            }
        }
    }
}
