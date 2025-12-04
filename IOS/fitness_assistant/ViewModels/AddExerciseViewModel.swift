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
    
    /// Load categories - placeholder for backend integration
    func loadCategories() {
        isLoading = true
        errorMessage = nil
        
        // Simulate async loading
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            
            // TODO: Replace with actual backend call
            // let categories = try await exerciseService.fetchCategories()
            
            categories = ExerciseCategory.allCategories
            isLoading = false
        }
    }
    
    /// Load exercises for selected category
    func loadExercises(for category: ExerciseCategory) async {
        // Set everything immediately for instant navigation
        selectedCategory = category
        navigationDirection = .forward
        navigationState = .exerciseGrid
        isLoading = true
        errorMessage = nil
        
        // Load data in background (user already sees the new screen)
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // TODO: Replace with actual backend call
        // let exercises = try await exerciseService.fetchExercises(categoryId: category.id)
        
        exercises = CategorizedExercise.exercisesByCategory(category)
        isLoading = false
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
    
    func trackExerciseAdded(exerciseId: UUID) {
        // TODO: Implement analytics tracking
        print("✅ Exercise added to plan: \(exerciseId)")
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
