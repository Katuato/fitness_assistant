//
//  Onboarding.swift
//  fitness_assistant
//
//  Created by katuato on 24.11.2025.
//

import Foundation
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let backgroundImage: String
    let title: String
    let pageImage: String
}

class OnboardingData {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            backgroundImage: "onboarding_bg_1",
            title: "Hello\nI'm your\nAI-fitnessassistant",
            pageImage: ""
        ),
        OnboardingPage(
            backgroundImage: "onboarding_bg_2",
            title: "Here you can analyze\nyour exercise form\nwith AI\n",
            pageImage: "onboarding_ai_assistant"
        ),
        OnboardingPage(
            backgroundImage: "onboarding_bg_3",
            title: "And get\npersonalized tips\nto improve it",
            pageImage: "onboarding_ai_analysis"
        ),
        OnboardingPage(
            backgroundImage: "onboarding_bg_4",
            title: "Also you can compete\nwith friends and\nachieve your goals",
            pageImage: "onboarding_friends"
        ),
        OnboardingPage(
            backgroundImage: "onboarding_bg_5",
            title: "And discover new\nworkouts, perfectly\ntailored for you",
            pageImage: "onboarding_workouts"
        ),
        OnboardingPage(
            backgroundImage: "onboarding_bg_6",
            title: "LET'S GET\nSTARTED",
            pageImage: ""
        )
    ]
}
