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
    
    private let workoutService: WorkoutService
    
    init(workoutService: WorkoutService = WorkoutService()) {
        self.workoutService = workoutService
    }
    
    func loadData() async {
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
        todaysPlan.append(exercise)
    }
    
    func startExercise(_ exercise: Exercise) {
        print("Starting exercise: \(exercise.name)")
    }
    
    func viewAllExercises() {
        print("View all exercises tapped")
    }
}
