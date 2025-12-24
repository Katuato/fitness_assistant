//
//  AddExerciseViewModel.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 04.12.2025.
//

import Foundation
import SwiftUI

@MainActor
class AddExerciseViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var categories: [ExerciseCategory] = []
    @Published var selectedCategory: ExerciseCategory?
    @Published var exercises: [CategorizedExercise] = []
    @Published var selectedExercise: CategorizedExercise?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Navigation state
    enum NavigationState {
        case categorySelection
        case exerciseGrid
        case exerciseDetail
    }
    
    enum NavigationDirection {
        case forward
        case backward
    }
    
    @Published var navigationState: NavigationState = .categorySelection
    @Published var navigationDirection: NavigationDirection = .forward
    
    // MARK: - Initialization
    
    init() {
        loadCategories()
    }
    
    // MARK: - Public Methods
    
    /// Load categories from backend
    func loadCategories() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let categoryResponses = try await NetworkService.shared.getExerciseCategories()
                categories = categoryResponses.map { $0.toExerciseCategory() }
                isLoading = false
            } catch {
                errorMessage = "Failed to load categories: \(error.localizedDescription)"
                isLoading = false
                print("❌ Error loading categories: \(error)")
            }
        }
    }
    
    /// Load exercises for selected category from backend
    func loadExercises(for category: ExerciseCategory) async {
        // Set everything immediately for instant navigation
        selectedCategory = category
        navigationDirection = .forward
        navigationState = .exerciseGrid
        isLoading = true
        errorMessage = nil

        // Load data from backend (user already sees the new screen)
        do {
            let exerciseResponses = try await NetworkService.shared.getExercisesByCategory(categoryName: category.name)
            exercises = exerciseResponses.map { $0.toCategorizedExercise() }
            isLoading = false
        } catch {
            errorMessage = "Failed to load exercises: \(error.localizedDescription)"
            isLoading = false
            print("❌ Error loading exercises: \(error)")
        }
    }
    
    /// Select exercise and navigate to detail
    func selectExercise(_ exercise: CategorizedExercise) {
        selectedExercise = exercise
        navigationDirection = .forward
        navigationState = .exerciseDetail
        trackExerciseViewed(exerciseId: exercise.id)
    }
    
    /// Navigate back from exercise detail to grid
    func navigateBackToGrid() {
        selectedExercise = nil
        navigationDirection = .backward
        navigationState = .exerciseGrid
    }
    
    /// Navigate back to category selection
    func navigateBackToCategories() {
        selectedCategory = nil
        selectedExercise = nil
        exercises = []
        navigationDirection = .backward
        navigationState = .categorySelection
    }
    
    /// Reset to initial state
    func reset() {
        navigationState = .categorySelection
        selectedCategory = nil
        selectedExercise = nil
        exercises = []
    }
    
    // MARK: - Analytics (Placeholder)
    
    private func trackExerciseViewed(exerciseId: UUID) {
        // TODO: Implement analytics tracking
        print("📊 Exercise viewed: \(exerciseId)")
    }
    
    func trackExerciseAdded(exercise: CategorizedExercise) {
        print("📊 Exercise viewed: \(exercise.id)")
    }
}

// MARK: - Future Backend Service Integration
/*
 Protocol for future backend service:
 
 protocol AddExerciseService {
     func fetchCategories() async throws -> [ExerciseCategory]
     func fetchExercises(categoryId: UUID) async throws -> [CategorizedExercise]
     func searchExercises(query: String) async throws -> [CategorizedExercise]
     func trackExerciseAnalytics(exerciseId: UUID, action: AnalyticsAction) async throws
 }
 */
