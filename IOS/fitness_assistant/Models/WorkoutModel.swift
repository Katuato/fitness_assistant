//
//  WorkoutModel.swift
//  fitness_assistant
//
//  Created by katuato on 27.11.2025.
//

import Foundation


struct WorkoutStatsResponse: Codable {
    let workoutsCount: Int
    let dayStreak: Int
    let accuracy: Int
}

struct WorkoutStats: Identifiable, Codable {
    let id = UUID()
    let workoutsCount: Int
    let dayStreak: Int
    let accuracy: Int

    enum CodingKeys: String, CodingKey {
        case workoutsCount, dayStreak, accuracy
    }
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



struct TodaysPlanResponse: Codable {
    let exercises: [TodaysPlanExercise]
    let totalExercises: Int
    let completedExercises: Int
}

struct TodaysPlanExercise: Codable, Identifiable {
    let id: Int  // plan_exercise_id
    let exerciseId: Int  // exercise_id из таблицы exercises
    let name: String
    let sets: Int
    let reps: Int
    let isCompleted: Bool
    let description: String?
    let difficulty: String?
    let targetMuscles: [String]
    let imageUrl: String?


    func toExercise() -> Exercise {
        Exercise(
            name: name,
            sets: sets,
            reps: reps,
            accuracy: nil,
            isCompleted: isCompleted
        )
    }
}



struct PlanExerciseCreateRequest: Codable {
    let exercise_id: Int
    let sets: Int
    let reps: Int
    let order_index: Int?

    init(exerciseId: Int, sets: Int, reps: Int, orderIndex: Int? = nil) {
        self.exercise_id = exerciseId
        self.sets = sets
        self.reps = reps
        self.order_index = orderIndex
    }
}



struct WeeklyStatsResponse: Codable {
    let weekLabel: String
    let averageAccuracy: Double
    let dailyAccuracies: [DayAccuracyResponse]
}

struct DayAccuracyResponse: Codable {
    let day: String
    let accuracy: Double
}


struct RecentSessionResponse: Codable, Identifiable {
    let id: Int
    let date: Date
    let exerciseCount: Int
    let totalTime: Int
    let accuracy: Int
    let bodyPart: String
}

struct UserDailyPlanResponse: Codable, Identifiable {
    let id: Int
    let userId: Int
    let planDate: Date
    let createdAt: Date
    let updatedAt: Date
    let exercises: [PlanExerciseResponse]
}

struct PlanExerciseResponse: Codable, Identifiable {
    let id: Int
    let planId: Int
    let exerciseId: Int
    let sets: Int
    let reps: Int
    let orderIndex: Int
    let isCompleted: Bool
    let completedAt: Date?
    let exerciseName: String
    let exerciseDescription: String?
    let exerciseDifficulty: String?
    let exerciseImageUrl: String?
    let targetMuscles: [String]
}

struct ExerciseDetail: Codable {
    let id: Int
    let name: String
    let description: String?
    let difficulty: String?
    let imageUrl: String?
    let muscles: [ExerciseMuscle]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case difficulty
        case imageUrl = "image_url"
        case muscles
    }
}

struct ExerciseMuscle: Codable {
    let muscle: MuscleDetail
}

struct MuscleDetail: Codable {
    let id: Int
    let name: String
}

struct UserDailyPlanCreate: Codable {
    let planDate: String?
    let exercises: [PlanExerciseCreateRequest]

    enum CodingKeys: String, CodingKey {
        case planDate = "plan_date"
        case exercises
    }

    init(planDate: Date? = nil, exercises: [PlanExerciseCreateRequest] = []) {
        if let date = planDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.planDate = dateFormatter.string(from: date)
        } else {
            self.planDate = nil
        }
        self.exercises = exercises
    }
}

struct WorkoutPlan: Identifiable {
    let id = UUID()
    let exercises: [Exercise]
}

// DEPRECATED: Mock data - to be removed after backend integration
@available(*, deprecated, message: "Use API data instead")
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
