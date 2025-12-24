//
//  HomeView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var navigateToAnalysis: Bool
    @Binding var selectedPlanExerciseForPreview: TodaysPlanExercise?
    @Binding var showAddExercise: Bool
    @State private var showWorkoutPlansSheet = false
    
    // Animation states
    @State private var headerAppear = false
    @State private var statsAppear = false
    @State private var contentAppear = false
    @State private var gradientRotation: Double = 0
    
    init(
        navigateToAnalysis: Binding<Bool> = .constant(false),
        selectedPlanExerciseForPreview: Binding<TodaysPlanExercise?> = .constant(nil),
        showAddExercise: Binding<Bool> = .constant(false)
    ) {
        self._navigateToAnalysis = navigateToAnalysis
        self._selectedPlanExerciseForPreview = selectedPlanExerciseForPreview
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
            } else if let errorMessage = viewModel.errorMessage {
                // Show error state
                ErrorView(
                    message: errorMessage,
                    onRetry: {
                        Task {
                            await viewModel.loadData()
                        }
                    }
                )
            } else {
                // Show actual content
                contentView
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .onAppear {
            startAnimations()
        }
        .onDisappear {
            // Отменяем загрузку данных при уходе с экрана
            viewModel.cancelLoading()
        }
        .sheet(isPresented: $viewModel.showWorkoutPlans) {
            WorkoutPlansView()
        }
    }

    private var contentView: some View {
        ZStack {
            AnimatedBackground()

            VStack(alignment: .leading, spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 24)

                // Stats Section
                if let stats = viewModel.stats {
                    statsSection(stats: stats)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 28)
                }

                // Today's Plan Section
                VStack(alignment: .leading, spacing: 0) {
                    planHeaderSection
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Scrollable exercises list
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            if let todaysPlan = viewModel.todaysPlan {
                                ForEach(todaysPlan.exercises, id: \.id) { planExercise in
                                    ExerciseCard(
                                        planExercise: planExercise,
                                        onPlayTapped: {
                                            if !planExercise.isCompleted {
                                                viewModel.startExercise(planExercise)
                                                navigateToAnalysis = true
                                            }
                                        },
                                        onCompleteTapped: {
                                            Task {
                                                await viewModel.toggleExerciseCompletion(
                                                    planExerciseId: planExercise.id,
                                                    completed: !planExercise.isCompleted
                                                )
                                            }
                                        },
                                    onCardTapped: {
                                        selectedPlanExerciseForPreview = planExercise
                                    }
                                    )
                                }
                            }

                            AddExerciseButton(action: {
                                showAddExercise = true
                            })

                            Color.clear.frame(height: 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }

                Spacer(minLength: 0)
            }
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
                
                if let todaysPlan = viewModel.todaysPlan {
                    Text("\(todaysPlan.exercises.count) exercises")
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

// MARK: - Loading Skeleton

struct HomeViewLoadingSkeleton: View {
    @State private var shimmer: Bool = false

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack(alignment: .leading, spacing: 0) {
                // Header skeleton
                HStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 200, height: 32)
                        .cornerRadius(8)
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 24)

                // Stats section skeleton
                HStack(spacing: 16) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 80)
                        .cornerRadius(16)

                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 80)
                        .cornerRadius(16)

                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 80)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // Today's plan section skeleton
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 120, height: 24)
                            .cornerRadius(6)
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 20)
                            .cornerRadius(4)
                    }
                    .padding(.horizontal, 20)

                    // Exercise cards
                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 80)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
        }
        .shimmer()
    }
}

// MARK: - Error View

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Something went wrong")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: onRetry) {
                Text("Try Again")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                    )
            }
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
