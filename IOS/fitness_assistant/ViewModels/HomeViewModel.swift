//
//  HomeViewModel.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var stats: WorkoutStats?
    @Published var todaysPlan: TodaysPlanResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Текущий выполняемый exercise ID для отметки выполненным после анализа
    @Published var currentAnalyzingExerciseId: Int?

    // Навигация
    @Published var showWorkoutPlans: Bool = false

    private lazy var workoutPlanService: WorkoutPlanService = WorkoutPlanService()
    private lazy var statsService: StatsService = StatsService()

    // Task management для отмены запросов
    private var currentDataTask: Task<Void, Never>?

    init() {}

    deinit {
        // Отменяем текущий task при уничтожении ViewModel
        currentDataTask?.cancel()
    }

    func loadData() async {
        // Отменяем предыдущий запрос если он еще выполняется
        currentDataTask?.cancel()

        currentDataTask = Task {
            isLoading = true
            errorMessage = nil

            do {
                // Загружаем данные параллельно
                async let statsLoad: () = statsService.loadWorkoutStats()
                async let planLoad: () = workoutPlanService.loadTodaysPlan()

                // Ждем завершения обоих запросов
                try await statsLoad
                try await planLoad

                // Проверяем, не была ли задача отменена
                try Task.checkCancellation()

                // Обновляем UI
                self.stats = statsService.workoutStats
                self.todaysPlan = workoutPlanService.todaysPlan

                // Обработка ошибок
                if let error = statsService.errorMessage ?? workoutPlanService.errorMessage {
                    self.errorMessage = error
                }

            } catch is CancellationError {
                // Запрос был отменен - ничего не делаем
                print("🏠 HomeView data loading was cancelled")
                return
            } catch {
                // Обработка других ошибок
                self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                print("❌ Error loading home data: \(error)")
            }

            isLoading = false
        }

        // Ждем завершения задачи
        await currentDataTask?.value
    }

    func refreshData() async {
        await loadData()
    }

    func cancelLoading() {
        currentDataTask?.cancel()
        currentDataTask = nil
        isLoading = false
    }

    func addExercise(_ categorizedExercise: CategorizedExercise) async {
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

        await workoutPlanService.addExercise(
            exerciseId: exerciseId,
            sets: categorizedExercise.sets,
            reps: categorizedExercise.reps
        )

        // Обновляем план
        todaysPlan = workoutPlanService.todaysPlan
    }

    private func getBackendExerciseId(for exercise: CategorizedExercise) -> Int? {
        // TODO: В будущем нужно загружать упражнения с бэкенда по категориям
        // и использовать реальные ID из API

        // Маппинг на основе названий из базы данных
        // Названия должны точно совпадать с тем, что приходит из AddExerciseView
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

    func removeExercise(at planExerciseId: Int) async {
        await workoutPlanService.removeExercise(planExerciseId: planExerciseId)
        todaysPlan = workoutPlanService.todaysPlan
    }

    func toggleExerciseCompletion(planExerciseId: Int, completed: Bool) async {
        await workoutPlanService.toggleExerciseCompletion(
            planExerciseId: planExerciseId,
            completed: completed
        )
        todaysPlan = workoutPlanService.todaysPlan
    }

    func startExercise(_ planExercise: TodaysPlanExercise) {
        currentAnalyzingExerciseId = planExercise.id
        print("Starting exercise: \(planExercise.name) (ID: \(planExercise.id))")
    }

    func completeCurrentExercise() async {
        if let exerciseId = currentAnalyzingExerciseId {
            await toggleExerciseCompletion(planExerciseId: exerciseId, completed: true)
            currentAnalyzingExerciseId = nil
        }
    }

    func viewAllExercises() {
        showWorkoutPlans = true
    }
}
