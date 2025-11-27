//
//  DashboardService.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation

/// Service responsible for fetching dashboard-related data
/// In the future, this will connect to the backend API
class DashboardService {
    
    // MARK: - Public Methods
    
    /// Fetches weekly statistics
    /// - Returns: WeeklyStats object
    func fetchWeeklyStats() async throws -> WeeklyStats {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return createMockWeeklyStats()
    }
    
    /// Fetches recent workout sessions
    /// - Returns: Array of WorkoutSession objects
    func fetchRecentSessions() async throws -> [WorkoutSession] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return createMockSessions()
    }
    
    // MARK: - Mock Data Generation
    // TODO: Replace with actual API calls when backend is ready
    
    private func createMockWeeklyStats() -> WeeklyStats {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let accuracies: [Double] = [85, 88, 92, 89, 95, 91, 93]
        
        let dailyAccuracies = zip(days, accuracies).map { day, accuracy in
            DayAccuracy(day: day, accuracy: accuracy)
        }
        
        let average = accuracies.reduce(0, +) / Double(accuracies.count)
        
        return WeeklyStats(
            weekLabel: "This week",
            averageAccuracy: average,
            dailyAccuracies: dailyAccuracies
        )
    }
    
    private func createMockSessions() -> [WorkoutSession] {
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 14
        components.minute = 30
        let todaySession = calendar.date(from: components)!
        
        var octComponents = DateComponents()
        octComponents.year = 2024
        octComponents.month = 10
        octComponents.day = 21
        octComponents.hour = 9
        octComponents.minute = 30
        let octSession = calendar.date(from: octComponents)!
        
        return [
            WorkoutSession(
                date: todaySession,
                exerciseCount: 2,
                totalTime: 45,
                accuracy: 82,
                bodyPart: "Upper Body"
            ),
            WorkoutSession(
                date: octSession,
                exerciseCount: 4,
                totalTime: 85,
                accuracy: 61,
                bodyPart: "Full Body"
            )
        ]
    }
}
