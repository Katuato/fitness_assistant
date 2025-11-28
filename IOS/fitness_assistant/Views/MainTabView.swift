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
        // Настройка TabBar один раз при инициализации
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0)
        
        // Убираем разделительную линию
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        
        // Настройка цветов иконок для всех состояний
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        itemAppearance.selected.iconColor = UIColor.systemOrange
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        // Применяем ко всем состояниям TabBar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Для iOS 15+
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        ZStack {
            // Основной фон для всех экранов
            Color.customBackground
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeView()
                    .environmentObject(workoutService)
                    .background(Color.customBackground.ignoresSafeArea())
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "circle.grid.3x3.fill" : "circle.grid.3x3")
                    }
                    .tag(0)
                
                AnalysisView()
                    .background(Color.customBackground.ignoresSafeArea())
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "video.fill" : "video")
                    }
                    .tag(1)
                
                DashboardView()
                    .background(Color.customBackground.ignoresSafeArea())
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "chart.xyaxis.line" : "chart.line.uptrend.xyaxis")
                    }
                    .tag(2)
                
                ProfileView()
                    .environmentObject(onboardingService)
                    .background(Color.customBackground.ignoresSafeArea())
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    }
                    .tag(3)
            }
            .tint(.orange)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(OnboardingService())
}
