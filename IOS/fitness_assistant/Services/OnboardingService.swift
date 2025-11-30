//
//  OnboardingService.swift
//  fitness_assistant
//
//  Created by katuato on 25.11.2025.
//

import Foundation

class OnboardingService: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    init() {
        //Онбординг работает при каждом запускe: для возвращение коректной работы удалить 19 строку и раскомментировать
        self.hasCompletedOnboarding = false
//        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}
