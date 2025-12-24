//
//  WorkoutPlansViewModel.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 02.12.2025.
//

import Foundation
import SwiftUI

@MainActor
class WorkoutPlansViewModel: ObservableObject {
    @Published var userPlans: [UserDailyPlanResponse] = []
    @Published var selectedDate: Date = Date()
    @Published var selectedDatePlan: TodaysPlanResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    func loadUserPlans() async {
        isLoading = true
        errorMessage = nil

        do {
            userPlans = try await networkService.getUserPlans()
            // После загрузки планов, загрузим план на выбранную дату
            await loadPlanForSelectedDate()
        } catch {
            errorMessage = "Failed to load workout plans: \(error.localizedDescription)"
            print("❌ Error loading user plans: \(error)")
        }

        isLoading = false
    }

    func loadPlanForSelectedDate() async {
        do {
            selectedDatePlan = try await networkService.getPlanByDate(selectedDate)
        } catch {
            errorMessage = "Failed to load plan for selected date: \(error.localizedDescription)"
            print("❌ Error loading plan for date \(selectedDate): \(error)")
            // Если план не найден, установим пустой план
            selectedDatePlan = TodaysPlanResponse(exercises: [], totalExercises: 0, completedExercises: 0)
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        Task {
            await loadPlanForSelectedDate()
        }
    }

    func refreshData() async {
        await loadUserPlans()
    }

    func addExercise(_ categorizedExercise: CategorizedExercise) async {
        do {
            // Use the backend exerciseId if available, otherwise fall back to name mapping
            let exerciseId: Int
            if let backendId = categorizedExercise.exerciseId {
                exerciseId = backendId
            } else {
                guard let mappedId = getBackendExerciseId(for: categorizedExercise) else {
                    print("❌ Error: Exercise '\(categorizedExercise.name)' not mapped to backend ID")
                    return
                }
                exerciseId = mappedId
            }

            // Create plan for the selected date if it doesn't exist
            let endpoint = "/workout-plans"
            let body = UserDailyPlanCreate(
                planDate: selectedDate,
                exercises: [PlanExerciseCreateRequest(
                    exerciseId: exerciseId,
                    sets: categorizedExercise.sets,
                    reps: categorizedExercise.reps
                )]
            )

            // Try to create/update plan
            let _: UserDailyPlanResponse = try await networkService.post(endpoint: endpoint, body: body)

            // Reload the plan for selected date
            await loadPlanForSelectedDate()

        } catch {
            errorMessage = "Failed to add exercise: \(error.localizedDescription)"
            print("❌ Error adding exercise: \(error)")
        }
    }

    private func getBackendExerciseId(for exercise: CategorizedExercise) -> Int? {
        // Mapping based on names from the database
        let exerciseMapping: [String: Int] = [
            "Push-Ups": 154,
            "Pull-Ups": 162,
            "Bench Press": 153,
            "Squats": 157,
            "Deadlifts": 161,
            "Lunges": 158,
            "Plank": 169,
            "Bicep Curls": 149,
        ]

        return exerciseMapping[exercise.name]
    }
}
