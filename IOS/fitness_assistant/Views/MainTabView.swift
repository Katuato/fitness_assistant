//
//  MainTabView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var workoutService = WorkoutService()
    @EnvironmentObject var onboardingService: OnboardingService
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        appearance.backgroundEffect = nil
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        itemAppearance.selected.iconColor = UIColor.systemOrange
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
        
        UIScrollView.appearance().backgroundColor = .clear

        UIView.appearance(whenContainedInInstancesOf: [UITabBar.self]).backgroundColor = .clear
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // TAB 0 — Home
            ZStack {
                Color.customBackground.ignoresSafeArea()
                HomeView()
                    .environmentObject(workoutService)
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "circle.grid.3x3.fill" : "circle.grid.3x3")
            }
            .tag(0)
            
            // TAB 1 — Analysis
            ZStack {
                Color.customBackground.ignoresSafeArea()
                AnalysisView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "video.fill" : "video")
            }
            .tag(1)
            
            // TAB 2 — Dashboard
            ZStack {
                Color.customBackground.ignoresSafeArea()
                DashboardView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "chart.xyaxis.line" : "chart.line.uptrend.xyaxis")
            }
            .tag(2)
            
            // TAB 3 — Profile
            ZStack {
                Color.customBackground.ignoresSafeArea()
                ProfileView()
//                    .environmentObject(onboardingService)
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "person.fill" : "person")
            }
            .tag(3)
        }
        .tint(.orange)
        .toolbarBackground(.hidden, for: .tabBar)
        .background(Color.customBackground.ignoresSafeArea())
    }
}

#Preview {
    MainTabView()
        .environmentObject(OnboardingService())
}
