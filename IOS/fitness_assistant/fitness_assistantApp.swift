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
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        Color.darkBackground
                .ignoresSafeArea()
        WindowGroup {
            Group {
                if onboardingService.hasCompletedOnboarding {
                    //Main or log in/reg
                } else {
                    OnboardingView()
                        .environmentObject(onboardingService)
                }
            }
            .animation(.easeInOut, value: onboardingService.hasCompletedOnboarding)
        }
    }
}