//
//  ExercisePreviewViewModel.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 02.12.2025.
//

import Foundation
import SwiftUI

@MainActor
class ExercisePreviewViewModel: ObservableObject {
    @Published var previewData: ExercisePreviewData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Public Methods
    
    /// Load exercise preview data - placeholder for backend integration
    func loadExercisePreview(for exercise: Exercise) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // TODO: Replace with actual backend call
        // let data = try await exerciseService.fetchPreviewData(exerciseId: exercise.id)
        
        // For now, use mock data based on exercise name
        previewData = getMockData(for: exercise)
        
        isLoading = false
    }
    
    /// Track analytics when user views preview - placeholder
    func trackPreviewViewed(exerciseId: UUID) {
        // TODO: Implement analytics tracking
        print("📊 Preview viewed for exercise: \(exerciseId)")
    }
    
    /// Track when user starts AI tracking from preview
    func trackStartAITracking(exerciseId: UUID) {
        // TODO: Implement analytics tracking
        print("🎯 AI Tracking started from preview for exercise: \(exerciseId)")
    }
    
    // MARK: - Private Methods
    
    private func getMockData(for exercise: Exercise) -> ExercisePreviewData {
        // Match exercise name to mock data
        switch exercise.name.lowercased() {
        case let name where name.contains("squat"):
            return ExercisePreviewData.mockSquats
        case let name where name.contains("bench"):
            return ExercisePreviewData.mockBenchPress
        case let name where name.contains("deadlift"):
            return ExercisePreviewData.mockDeadlifts
        default:
            // Create dynamic preview data
            return ExercisePreviewData(
                id: exercise.id,
                exercise: exercise,
                targetMuscles: ["Full Body"],
                description: "A great exercise for building strength and endurance. Focus on proper form and controlled movements.",
                instructions: [
                    "Warm up properly before starting",
                    "Maintain proper form throughout",
                    "Breathe consistently during movement",
                    "Focus on controlled repetitions",
                    "Rest adequately between sets"
                ],
                videoThumbnailURL: nil,
                videoURL: nil,
                difficulty: .intermediate,
                estimatedDuration: 10,
                caloriesBurn: 50
            )
        }
    }
}

// MARK: - Future Backend Service Integration
/*
 Protocol for future backend service:
 
 protocol ExercisePreviewService {
     func fetchPreviewData(exerciseId: UUID) async throws -> ExercisePreviewData
     func fetchVideoURL(exerciseId: UUID) async throws -> URL
     func trackPreviewAnalytics(exerciseId: UUID, action: AnalyticsAction) async throws
 }
 */
