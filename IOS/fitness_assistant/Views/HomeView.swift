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
    
    @State private var gradientRotation: Double = 0
    @State private var headerAppear = false
    @State private var statsAppear = false
    @State private var contentAppear = false
    
    init(
        navigateToAnalysis: Binding<Bool> = .constant(false),
        selectedExerciseForPreview: Binding<Exercise?> = .constant(nil),
        showAddExercise: Binding<Bool> = .constant(false)
    ) {
        self._navigateToAnalysis = navigateToAnalysis
        self._selectedExerciseForPreview = selectedExerciseForPreview
        self._showAddExercise = showAddExercise
    }
    
    // MARK: - Brand Colors
    
    private var brandPurple: Color {
        Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                // Show shimmer loading skeleton
                HomeViewLoadingSkeleton()
                    .transition(.opacity)
            } else {
                // Show actual content
                ZStack {
                    AnimatedBackground()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection
                            .padding(.horizontal, 20)
                            .padding(.top, 60)
                            .padding(.bottom, 24)
                            .opacity(headerAppear ? 1 : 0)
                            .offset(y: headerAppear ? 0 : -20)
                        
                        // Stats Section with Enhanced Design
                        if let stats = viewModel.stats {
                            statsSection(stats: stats)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 28)
                                .opacity(statsAppear ? 1 : 0)
                                .offset(y: statsAppear ? 0 : 20)
                        }
                        
                        // Today's Plan Section
                        VStack(alignment: .leading, spacing: 0) {
                            planHeaderSection
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            
                            // Scrollable exercises list
                            ScrollView(showsIndicators: false) {
                                LazyVStack(spacing: 12) {
                                    ForEach(Array(viewModel.todaysPlan.enumerated()), id: \.element.id) { index, exercise in
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
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .leading).combined(with: .opacity)
                                        ))
                                        .opacity(contentAppear ? 1 : 0)
                                        .offset(x: contentAppear ? 0 : 50)
                                        .animation(
                                            .spring(response: 0.6, dampingFraction: 0.8)
                                                .delay(Double(index) * 0.08),
                                            value: contentAppear
                                        )
                                    }
                                    
                                    AddExerciseButton(action: {
                                        showAddExercise = true
                                    })
                                    .opacity(contentAppear ? 1 : 0)
                                    .offset(x: contentAppear ? 0 : 50)
                                    .animation(
                                        .spring(response: 0.6, dampingFraction: 0.8)
                                            .delay(Double(viewModel.todaysPlan.count) * 0.08),
                                        value: contentAppear
                                    )
                                    
                                    // Bottom padding
                                    Color.clear.frame(height: 20)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        Spacer(minLength: 0)
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
        .task {
            viewModel.setWorkoutService(workoutService)
            await viewModel.loadData()
        }
        .onReceive(workoutService.$todaysPlan) { plan in
            viewModel.todaysPlan = plan.exercises
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            Text("Ready to Train?")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .white,
                            .white.opacity(0.9)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Stats Section
    
    private func statsSection(stats: WorkoutStats) -> some View {
        HStack(spacing: 12) {
            SimpleStatCard(
                value: "\(stats.workoutsCount)",
                label: "Workouts",
                accentColor: accentGreen
            )
            
            SimpleStatCard(
                value: "\(stats.dayStreak)",
                label: "Day Streak",
                accentColor: brandOrange
            )
            
            SimpleStatCard(
                value: "\(stats.accuracy)%",
                label: "Accuracy",
                accentColor: brandPurple
            )
        }
    }
    
    // MARK: - Plan Header Section
    
    private var planHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Plan")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                if !viewModel.todaysPlan.isEmpty {
                    Text("\(viewModel.todaysPlan.count) exercises")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
            
            Button(action: viewModel.viewAllExercises) {
                HStack(spacing: 6) {
                    Text("View All")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(
                    LinearGradient(
                        colors: [brandOrange, brandOrange.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(brandOrange.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(brandOrange.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .opacity(contentAppear ? 1 : 0)
        .offset(y: contentAppear ? 0 : -10)
    }
    
    // MARK: - Animations
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
            headerAppear = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
            statsAppear = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5)) {
            contentAppear = true
        }
        
        // Continuous gradient rotation
        withAnimation(
            .linear(duration: 20)
                .repeatForever(autoreverses: false)
        ) {
            gradientRotation = 360
        }
    }
}

// MARK: - Simple Stat Card (Matching Design)

struct SimpleStatCard: View {
    let value: String
    let label: String
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(accentColor)
            
            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(WorkoutService())
        .preferredColorScheme(.dark)
}
