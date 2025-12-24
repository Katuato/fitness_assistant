//
//  ExercisePreviewViewModel.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 02.12.2025.
//

import Foundation
import SwiftUI

@MainActor
final class ExercisePreviewViewModel: ObservableObject {
    @Published var previewData: ExercisePreviewData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    func loadExercisePreview(for exercise: Exercise, exerciseId: Int? = nil) async {
        await loadExercisePreviewFromId(exerciseId)
    }

    func loadExercisePreview(for planExercise: TodaysPlanExercise) async {
        isLoading = true
        errorMessage = nil

        print("🔄 Loading exercise preview for plan exercise: \(planExercise.name) (ID: \(planExercise.exerciseId))")

        // Для упражнений из плана используем описание и мышцы из плана,
        // но загружаем инструкции и другие детали из API
        do {
            print("📡 Making API call to /exercises/\(planExercise.exerciseId)")
            let response = try await networkService.getExerciseDetail(exerciseId: planExercise.exerciseId)
            print("✅ API call successful for exercise: \(response.name)")

            // Используем инструкции из API
            let instructions = response.instructions ?? []

            previewData = ExercisePreviewData(
                id: UUID(), // dummy UUID
                exercise: Exercise(
                    name: planExercise.name,
                    sets: planExercise.sets,
                    reps: planExercise.reps,
                    accuracy: nil,
                    isCompleted: planExercise.isCompleted
                ),
                targetMuscles: planExercise.targetMuscles,
                description: planExercise.description ?? response.description ?? "No description available",
                instructions: instructions,
                videoThumbnailURL: planExercise.imageUrl ?? response.imageUrl,
                videoURL: nil,
                difficulty: difficultyFromString(planExercise.difficulty),
                estimatedDuration: response.estimatedDuration ?? 10,
                caloriesBurn: response.caloriesBurn ?? 50
            )
        } catch {
            errorMessage = "Failed to load exercise details: \(error.localizedDescription)"
            print("❌ Error loading exercise: \(error)")
        }

        isLoading = false
    }

    private func loadExercisePreviewFromId(_ exerciseId: Int?) async {
        isLoading = true
        errorMessage = nil

        // Если есть ID - загружаем с бэкенда
        if let id = exerciseId {
            do {
                let response = try await networkService.getExerciseDetail(exerciseId: id)
                previewData = ExercisePreviewData(from: response)
            } catch {
                errorMessage = "Failed to load exercise details: \(error.localizedDescription)"
                print("❌ Error loading exercise: \(error)")

                // Fallback to mock data
                loadMockPreviewData(for: Exercise(name: "", sets: 0, reps: 0, accuracy: nil, isCompleted: false))
            }
        } else {
            // Используем mock данные если нет ID
            loadMockPreviewData(for: Exercise(name: "", sets: 0, reps: 0, accuracy: nil, isCompleted: false))
        }

        isLoading = false
    }

    func trackPreviewViewed(exerciseId: UUID) {
        print("📊 Exercise preview viewed: \(exerciseId)")
    }

    func trackStartAITracking(exerciseId: UUID) {
        print("🎥 Started AI tracking for: \(exerciseId)")
    }

    private func difficultyFromString(_ difficulty: String?) -> ExercisePreviewData.DifficultyLevel {
        switch difficulty?.lowercased() {
        case "beginner":
            return .beginner
        case "advanced":
            return .advanced
        default:
            return .intermediate
        }
    }

    private func loadMockPreviewData(for exercise: Exercise) {
        // Используем существующие mock данные как fallback
        switch exercise.name {
        case "Squats":
            previewData = .mockSquats
        case "Bench Press":
            previewData = .mockBenchPress
        case "Deadlifts":
            previewData = .mockDeadlifts
        default:
            // Generic preview data
            previewData = ExercisePreviewData(
                id: UUID(),
                exercise: exercise,
                targetMuscles: ["Full Body"],
                description: "A great exercise for building strength.",
                instructions: ["Follow proper form", "Start with lighter weight"],
                videoThumbnailURL: nil,
                videoURL: nil,
                difficulty: .intermediate,
                estimatedDuration: 10,
                caloriesBurn: 50
            )
        }
    }
}

// MARK: - Integration Complete

// ExercisePreviewViewModel теперь интегрирован с NetworkService
// и может загружать реальные данные из API или использовать mock данные как fallback
