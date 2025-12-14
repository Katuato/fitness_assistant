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
            Group {
                if onboardingService.hasCompletedOnboarding {
                    if authService.isAuthenticated {
                        MainTabView()
                            .environmentObject(onboardingService)
                            .environmentObject(authService)
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
