//
//  MainTabView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var currentTab: Tab = .firstTab

    var body: some View {
        TabView(selection: $currentTab) {
            MovieListView()
                .tabItem {
                    Label("Movies", systemImage: "1.circle")
                }
                .tag(Tab.firstTab)

            MovieListView()
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
