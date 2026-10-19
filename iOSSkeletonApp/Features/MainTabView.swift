//
//  MainTabView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var networkMonitor: NetworkMonitor

    /// The shell only renders what the coordinator hands it; each tab's content
    /// is that tab's navigation stack.
    @ObservedObject var appCoordinator: AppCoordinator

    var body: some View {
        TabView(selection: $appCoordinator.selectedTab) {
            appCoordinator.presentable(for: .firstTab)
                .tabItem {
                    Label("Movies", systemImage: "1.circle")
                }
                .tag(Tab.firstTab)

            appCoordinator.presentable(for: .secondTab)
                .tabItem {
                    Label("Movies 2", systemImage: "2.circle")
                }
                .tag(Tab.secondTab)
        }
        .alert(
            "Network connection seems to be offline.",
            isPresented: $networkMonitor.isNotConnected
        ) {}
    }
}

enum Tab {
    case firstTab
    case secondTab
}
