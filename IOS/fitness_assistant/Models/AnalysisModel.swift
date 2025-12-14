//
//  AnalysisModel.swift
//  fitness_assistant
//
//  Created by Andrew Novoseltsev on 28.11.2025.
//

import Foundation

// MARK: - Analysis Stats

struct AnalysisStats: Codable {
    let reps: Int
    let sets: Int
    let timeSeconds: Int
}

// MARK: - Suggested Exercise

struct AnalysisExercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let level: String
    let durationSeconds: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        level: String,
        durationSeconds: Int
    ) {
        self.id = id
        self.name = name
        self.level = level
        self.durationSeconds = durationSeconds
    }
}

// MARK: - Mock Data

enum AnalysisMockData {
    static let stats = AnalysisStats(
        reps: 12,
        sets: 3,
        timeSeconds: 150 // 2:30
    )
    
    static let exercises: [AnalysisExercise] = [
        AnalysisExercise(
            name: "Squats",
            level: "Intermediate",
            durationSeconds: 180
        ),
        AnalysisExercise(
            name: "Squats",
            level: "Intermediate",
            durationSeconds: 180
        ),
        AnalysisExercise(
            name: "Lunges",
            level: "Beginner",
            durationSeconds: 150
        )
    ]
}
