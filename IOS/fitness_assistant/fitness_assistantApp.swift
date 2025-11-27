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
    //@StateObject private var appCoordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            // MARK: - Временно отключен онбординг для тестирования
            // MainTabView()
            
            // MARK: - Раскомментируйте код ниже, чтобы включить онбординг
            
            Group {
                if onboardingService.hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                        .environmentObject(onboardingService)
                }
            }
            .animation(.easeInOut, value: onboardingService.hasCompletedOnboarding)
            
        }
    }
}
