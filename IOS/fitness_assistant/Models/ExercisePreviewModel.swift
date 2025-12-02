//
//  ExercisePreviewModel.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 02.12.2025.
//

import Foundation

/// Extended exercise information for preview display
struct ExercisePreviewData: Identifiable {
    let id: UUID
    let exercise: Exercise
    let targetMuscles: [String]
    let description: String
    let instructions: [String]
    let videoThumbnailURL: String?
    let videoURL: String?
    let difficulty: DifficultyLevel
    let estimatedDuration: Int // in minutes
    let caloriesBurn: Int
    
    enum DifficultyLevel: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
}

// MARK: - Mock Data
extension ExercisePreviewData {
    static let mockSquats = ExercisePreviewData(
        id: UUID(),
        exercise: Exercise(
            name: "Squats",
            sets: 3,
            reps: 12,
            accuracy: 94,
            isCompleted: false
        ),
        targetMuscles: ["Quadriceps", "Glutes", "Hamstrings", "Core"],
        description: "A fundamental lower body exercise that strengthens your legs and core. Perfect for building functional strength and improving mobility.",
        instructions: [
            "Stand with feet shoulder-width apart",
            "Keep your chest up and core engaged",
            "Lower down as if sitting in a chair",
            "Push through heels to return to start",
            "Maintain neutral spine throughout"
        ],
        videoThumbnailURL: nil,
        videoURL: nil,
        difficulty: .intermediate,
        estimatedDuration: 8,
        caloriesBurn: 45
    )
    
    static let mockBenchPress = ExercisePreviewData(
        id: UUID(),
        exercise: Exercise(
            name: "Bench Press",
            sets: 4,
            reps: 10,
            accuracy: 89,
            isCompleted: false
        ),
        targetMuscles: ["Chest", "Triceps", "Shoulders"],
        description: "The classic upper body exercise for building chest and arm strength. Essential for developing pushing power and upper body mass.",
        instructions: [
            "Lie flat on bench with feet on floor",
            "Grip bar slightly wider than shoulders",
            "Lower bar to mid-chest with control",
            "Press up explosively to start position",
            "Keep shoulder blades retracted"
        ],
        videoThumbnailURL: nil,
        videoURL: nil,
        difficulty: .intermediate,
        estimatedDuration: 10,
        caloriesBurn: 60
    )
    
    static let mockDeadlifts = ExercisePreviewData(
        id: UUID(),
        exercise: Exercise(
            name: "Deadlifts",
            sets: 3,
            reps: 8,
            accuracy: nil,
            isCompleted: false
        ),
        targetMuscles: ["Back", "Hamstrings", "Glutes", "Core"],
        description: "The king of compound movements. Builds total body strength and power while developing proper hip hinge mechanics.",
        instructions: [
            "Stand with feet hip-width apart",
            "Hinge at hips and grip the bar",
            "Engage lats and brace your core",
            "Drive through heels to stand tall",
            "Control the weight back down"
        ],
        videoThumbnailURL: nil,
        videoURL: nil,
        difficulty: .advanced,
        estimatedDuration: 12,
        caloriesBurn: 70
    )
}
