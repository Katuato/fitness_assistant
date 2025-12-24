import Foundation
import Combine

@MainActor
class WorkoutPlanService: ObservableObject {


    @Published var todaysPlan: TodaysPlanResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?



    private let networkService: NetworkService


    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    func loadTodaysPlan() async {
        isLoading = true
        errorMessage = nil

        do {
            todaysPlan = try await networkService.getTodaysPlan()
        } catch {
            errorMessage = "Failed to load today's plan: \(error.localizedDescription)"
            print("❌ Error loading plan: \(error)")
        }

        isLoading = false
    }

    func addExercise(exerciseId: Int, sets: Int = 3, reps: Int = 12) async {
        isLoading = true
        errorMessage = nil

        do {
            todaysPlan = try await networkService.addExerciseToTodaysPlan(
                exerciseId: exerciseId,
                sets: sets,
                reps: reps
            )
        } catch {
            errorMessage = "Failed to add exercise: \(error.localizedDescription)"
            print("❌ Error adding exercise: \(error)")
        }

        isLoading = false
    }


    func removeExercise(planExerciseId: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            todaysPlan = try await networkService.removeExerciseFromPlan(
                planExerciseId: planExerciseId
            )
        } catch {
            errorMessage = "Failed to remove exercise: \(error.localizedDescription)"
            print("❌ Error removing exercise: \(error)")
        }

        isLoading = false
    }


    func toggleExerciseCompletion(planExerciseId: Int, completed: Bool) async {
        do {
            todaysPlan = try await networkService.markExerciseCompleted(
                planExerciseId: planExerciseId,
                completed: completed
            )
        } catch {
            errorMessage = "Failed to update exercise: \(error.localizedDescription)"
            print("❌ Error updating exercise: \(error)")
        }
    }

  
    // Удален метод getExercisesForUI() - теперь HomeView работает напрямую с TodaysPlanResponse
}