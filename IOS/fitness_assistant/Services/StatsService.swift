import Foundation
import Combine

@MainActor
class StatsService: ObservableObject {
    // MARK: - Published Properties

    @Published var workoutStats: WorkoutStats?
    @Published var weeklyStats: WeeklyStats?
    @Published var recentSessions: [WorkoutSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

   

    private let networkService: NetworkService



    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }



    
    func loadWorkoutStats() async {
        isLoading = true
        errorMessage = nil

        do {
            workoutStats = try await networkService.getWorkoutStats()
        } catch {
            errorMessage = "Failed to load stats: \(error.localizedDescription)"
            print("❌ Error loading stats: \(error)")

            workoutStats = WorkoutStats(workoutsCount: 0, dayStreak: 0, accuracy: 0)
        }

        isLoading = false
    }


    func loadWeeklyStats() async {
        isLoading = true
        errorMessage = nil

        do {
            weeklyStats = try await networkService.getWeeklyStats()
        } catch {
            errorMessage = "Failed to load weekly stats: \(error.localizedDescription)"
            print("❌ Error loading weekly stats: \(error)")
        }

        isLoading = false
    }

  
    func loadRecentSessions(limit: Int = 10) async {
        isLoading = true
        errorMessage = nil

        do {
            recentSessions = try await networkService.getRecentSessions(limit: limit)
        } catch {
            errorMessage = "Failed to load sessions: \(error.localizedDescription)"
            print("❌ Error loading sessions: \(error)")
            recentSessions = []
        }

        isLoading = false
    }


    func loadDashboardData() async {
        await loadWeeklyStats()
        await loadRecentSessions()
    }
}