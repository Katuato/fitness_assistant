//
//  HomeView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    init() {
        UIScrollView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HomeHeaderView()
                        .padding(.horizontal)
                    
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
                    
                    AITrackerCard()
                        .padding(.horizontal)
                    
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
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.todaysPlan) { exercise in
                                ExerciseCard(
                                    exercise: exercise,
                                    onPlayTapped: {
                                        viewModel.startExercise(exercise)
                                    }
                                )
                            }
                            
                            AddExerciseButton()
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 16)
                .background(Color.clear)
            }
            .background(Color.clear)
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

