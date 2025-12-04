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
    @Published var todaysPlan: [Exercise] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var workoutService: WorkoutService?
    
    init(workoutService: WorkoutService? = nil) {
        self.workoutService = workoutService
    }
    
    func setWorkoutService(_ service: WorkoutService) {
        self.workoutService = service
        // Update todaysPlan when service is set
        self.todaysPlan = service.todaysPlan.exercises
    }
    
    func loadData() async {
        guard let workoutService = workoutService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let statsData = workoutService.fetchStats()
            async let planData = workoutService.fetchTodaysPlan()
            
            self.stats = try await statsData
            self.todaysPlan = try await planData
        } catch {
            errorMessage = "Failed to load home data"
            print("Error loading home data: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        await loadData()
    }
    
    func addExercise(_ exercise: Exercise) {
        workoutService?.addExercise(exercise)
        // Manually update todaysPlan
        if let service = workoutService {
            todaysPlan = service.todaysPlan.exercises
        }
    }
    
    func startExercise(_ exercise: Exercise) {
        print("Starting exercise: \(exercise.name)")
    }
    
    func viewAllExercises() {
        print("View all exercises tapped")
    }
}
