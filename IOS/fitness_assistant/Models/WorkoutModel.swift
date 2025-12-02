//
//  WorkoutModel.swift
//  fitness_assistant
//
//  Created by katuato on 27.11.2025.
//

import Foundation

struct WorkoutStats: Identifiable {
    let id = UUID()
    let workoutsCount: Int
    let dayStreak: Int
    let accuracy: Int
}

struct Exercise: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: Int
    let accuracy: Int?
    let isCompleted: Bool
    
    // Equatable conformance - compare by id
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
}

struct WorkoutPlan: Identifiable {
    let id = UUID()
    let exercises: [Exercise]
}

class WorkoutData {
    static let mockStats = WorkoutStats(
        workoutsCount: 12,
        dayStreak: 42,
        accuracy: 91
    )
    
    static let mockExercises: [Exercise] = [
        Exercise(
            name: "Squats",
            sets: 3,
            reps: 12,
            accuracy: 94,
            isCompleted: false
        ),
        Exercise(
            name: "Bench Press",
            sets: 4,
            reps: 10,
            accuracy: 89,
            isCompleted: false
        ),
        Exercise(
            name: "Deadlifts",
            sets: 3,
            reps: 8,
            accuracy: nil,
            isCompleted: false
        )
    ]
    
    static let mockPlan = WorkoutPlan(exercises: mockExercises)
}
