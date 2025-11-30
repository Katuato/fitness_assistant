//
//  fitness_assistantApp.swift
//  fitness_assistant
//
//  Created by katuato on 24.11.2025.
//

import SwiftUI


@main
struct FitnessAssistantApp: App {
    @StateObject private var onboardingService = OnboardingService()
    @StateObject private var authService = AuthService() 
    var body: some Scene {
        WindowGroup {
            // MARK: - Временно отключен онбординг для тестирования
            // MainTabView()
            
            // MARK: - Раскомментируйте код ниже, чтобы включить онбординг
            
            Group {
                if onboardingService.hasCompletedOnboarding {
                    MainTabView()
                        .environmentObject(onboardingService)

                    if authService.isAuthenticated {
                        MainTabView()
                    } else {
                            AuthView()
                            .environmentObject(authService)
                    }
                } else {
                    OnboardingView()
                        .environmentObject(onboardingService)
                }
            }
            .animation(.easeInOut, value: onboardingService.hasCompletedOnboarding)
            .animation(.easeInOut, value: authService.isAuthenticated)
            
        }
    }
}
