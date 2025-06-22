//
//  MainTabView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI

struct MainTabView: View {
        
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var currentTab: Tab = .firstTab
    
    var body: some View {
        TabView {
            MovieListView(viewModel: .init())
                .tabItem {
                    Label("Movies", systemImage: "1.circle")
                }
                .tag(Tab.firstTab)
            
            MovieListView(viewModel: .init())
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
