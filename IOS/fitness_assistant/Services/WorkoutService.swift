//
//  WorkoutService.swift
//  fitness_assistant
//
//  Created by katuato on 27.11.2025.
//

import Foundation

class WorkoutService: ObservableObject {
    @Published var stats: WorkoutStats
    @Published var todaysPlan: WorkoutPlan
    
    init() {
        self.stats = WorkoutData.mockStats
        self.todaysPlan = WorkoutData.mockPlan
    }
    
    func fetchStats() async throws -> WorkoutStats {
        try await Task.sleep(nanoseconds: 500_000_000)
        return WorkoutData.mockStats
    }
    
    func fetchTodaysPlan() async throws -> [Exercise] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return WorkoutData.mockExercises
    }
    
    func updateStats(workoutsCount: Int? = nil, dayStreak: Int? = nil, accuracy: Int? = nil) {
        stats = WorkoutStats(
            workoutsCount: workoutsCount ?? stats.workoutsCount,
            dayStreak: dayStreak ?? stats.dayStreak,
            accuracy: accuracy ?? stats.accuracy
        )
    }
    
    func addExercise(_ exercise: Exercise) {
        var updatedExercises = todaysPlan.exercises
        updatedExercises.append(exercise)
        todaysPlan = WorkoutPlan(exercises: updatedExercises)
    }
    
    func removeExercise(at index: Int) {
        var updatedExercises = todaysPlan.exercises
        updatedExercises.remove(at: index)
        todaysPlan = WorkoutPlan(exercises: updatedExercises)
    }
}
