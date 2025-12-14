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
    
    private let dashboardService: DashboardService
    
    init(dashboardService: DashboardService = DashboardService()) {
        self.dashboardService = dashboardService
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let stats = dashboardService.fetchWeeklyStats()
            async let sessions = dashboardService.fetchRecentSessions()
            
            self.weeklyStats = try await stats
            self.recentSessions = try await sessions
        } catch {
            errorMessage = "Failed to load dashboard data"
            print("Error loading dashboard data: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        await loadData()
    }
}
