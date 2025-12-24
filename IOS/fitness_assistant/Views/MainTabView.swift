//
//  MainTabView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var onboardingService: OnboardingService
    @EnvironmentObject var authService: AuthService
    @State private var selectedTab = 0
    @State private var shouldNavigateToAnalysis = false
    @State private var selectedPlanExerciseForPreview: TodaysPlanExercise?
    @State private var showAddExercise = false
    
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
        NavigationStack {
        ZStack {
            // Main Tab View
            TabView(selection: $selectedTab) {
                // TAB 0 — Home
                ZStack {
                    Color.customBackground.ignoresSafeArea()
                    HomeView(
                        navigateToAnalysis: $shouldNavigateToAnalysis,
                        selectedPlanExerciseForPreview: $selectedPlanExerciseForPreview,
                        showAddExercise: $showAddExercise
                    )
                    .environmentObject(homeViewModel)
                }
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "circle.grid.3x3.fill" : "circle.grid.3x3")
                }
                .tag(0)
                
                // TAB 1 — Analysis
                ZStack {
                    Color.customBackground.ignoresSafeArea()
                    AnalysisView(onExerciseCompleted: {
                        selectedTab = 0 // Return to Home tab
                    })
                        .environmentObject(homeViewModel)
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
                        .environmentObject(onboardingService)
                        .environmentObject(authService)
                }
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                }
                .tag(3)
            }
            .tint(.orange)
            .toolbarBackground(.hidden, for: .tabBar)
            .background(Color.customBackground.ignoresSafeArea())
            .blur(radius: selectedPlanExerciseForPreview != nil || showAddExercise ? 10 : 0)
            .onChange(of: shouldNavigateToAnalysis) { oldValue, newValue in
                if newValue {
                    selectedTab = 1
                    shouldNavigateToAnalysis = false
                }
            }
            
            // Exercise Preview Overlay - Covers EVERYTHING including tab bar
            if let planExercise = selectedPlanExerciseForPreview {
                ExercisePreviewView(
                    planExercise: planExercise,
                    onDismiss: {
                        selectedPlanExerciseForPreview = nil
                    },
                    onStartTracking: {
                        shouldNavigateToAnalysis = true
                        selectedPlanExerciseForPreview = nil
                    },
                    onRemove: {
                        Task {
                            await homeViewModel.removeExercise(at: planExercise.id)
                            selectedPlanExerciseForPreview = nil
                        }
                    },
                    onToggleComplete: {
                        Task {
                            await homeViewModel.toggleExerciseCompletion(
                                planExerciseId: planExercise.id,
                                completed: !planExercise.isCompleted
                            )
                            selectedPlanExerciseForPreview = nil
                        }
                    }
                )
                .zIndex(999)
                .ignoresSafeArea()
                .transition(.opacity)
            }
            
            // Add Exercise Overlay - Covers EVERYTHING including tab bar
            if showAddExercise {
                AddExerciseView(
                    onDismiss: {
                        showAddExercise = false
                    },
                    onExerciseAdded: { categorizedExercise in
                        // Add exercise through homeViewModel
                        Task {
                            await homeViewModel.addExercise(categorizedExercise)
                        }
                        showAddExercise = false
                    }
                )
                .zIndex(999)
                .ignoresSafeArea()
                .transition(.opacity)
            }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedPlanExerciseForPreview != nil)
        .animation(.easeInOut(duration: 0.3), value: showAddExercise)
    }
}

#Preview {
    MainTabView()
        .environmentObject(OnboardingService())
}
