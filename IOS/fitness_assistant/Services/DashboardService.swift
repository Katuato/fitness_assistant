//
//  DashboardService.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation

class DashboardService {
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    // MARK: - Public Methods

    /// Получить недельную статистику
    func fetchWeeklyStats() async throws -> WeeklyStats {
        return try await networkService.getWeeklyStats()
    }

    /// Получить последние тренировки
    func fetchRecentSessions() async throws -> [WorkoutSession] {
        return try await networkService.getRecentSessions(limit: 10)
    }
}
