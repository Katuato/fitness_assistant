//
//  DashboardViewModel.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var weeklyStats: WeeklyStats?
    @Published var recentSessions: [WorkoutSession] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private lazy var statsService: StatsService = StatsService()

    init() {}

    func loadData() async {
        isLoading = true
        errorMessage = nil

        await statsService.loadDashboardData()

        // Обновляем UI
        self.weeklyStats = statsService.weeklyStats
        self.recentSessions = statsService.recentSessions

        if let error = statsService.errorMessage {
            self.errorMessage = error
        }

        isLoading = false
    }

    func refreshData() async {
        await loadData()
    }
}
