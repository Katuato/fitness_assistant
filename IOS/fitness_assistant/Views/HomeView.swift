//
//  HomeView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var workoutService: WorkoutService
    @Binding var navigateToAnalysis: Bool
    @Binding var selectedExerciseForPreview: Exercise?
    @Binding var showAddExercise: Bool
    
    init(
        navigateToAnalysis: Binding<Bool> = .constant(false),
        selectedExerciseForPreview: Binding<Exercise?> = .constant(nil),
        showAddExercise: Binding<Bool> = .constant(false)
    ) {
        self._navigateToAnalysis = navigateToAnalysis
        self._selectedExerciseForPreview = selectedExerciseForPreview
        self._showAddExercise = showAddExercise
    }
    
    var body: some View {
        ZStack {
            // Фон
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                
                // Header
                HomeHeaderView()
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // Stats
                if let stats = viewModel.stats {
                    HStack(spacing: 12) {
                        StatCard(
                            value: "\(stats.workoutsCount)",
                            label: "Workouts"
                        )
                        
                        StatCard(
                            value: "\(stats.dayStreak)",
                            label: "Day Streak"
                        )
                        
                        StatCard(
                            value: "\(stats.accuracy)%",
                            label: "Accuracy"
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Today's Plan
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Today's Plan")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: viewModel.viewAllExercises) {
                            Text("View All")
                                .foregroundColor(.orange)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Scrollable exercises list
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(viewModel.todaysPlan) { exercise in
                                ExerciseCard(
                                    exercise: exercise,
                                    onPlayTapped: {
                                        viewModel.startExercise(exercise)
                                        navigateToAnalysis = true
                                    },
                                    onCardTapped: {
                                        selectedExerciseForPreview = exercise
                                    }
                                )
                            }
                            
                            AddExerciseButton(action: {
                                showAddExercise = true
                            })
                            
                            // Bottom padding
                            Color.clear.frame(height: 20)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 0)
            }
            
            // Loading Overlay
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            }
        }
        .task {
            viewModel.setWorkoutService(workoutService)
            await viewModel.loadData()
        }
        .onReceive(workoutService.$todaysPlan) { plan in
            viewModel.todaysPlan = plan.exercises
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WorkoutService())
        .preferredColorScheme(.dark)
}
