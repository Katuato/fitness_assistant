//
//  WorkoutPlansView.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 02.12.2025.
//

import SwiftUI

struct WorkoutPlansView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = WorkoutPlansViewModel()
    @State private var showDatePicker = false
    @State private var showAddExercise = false


    // Animation states
    @State private var headerAppear = false
    @State private var contentAppear = false

    // Brand Colors
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
            if viewModel.isLoading && viewModel.userPlans.isEmpty {
                // Show shimmer loading skeleton
                WorkoutPlansLoadingSkeleton()
                    .transition(.opacity)
            } else if let errorMessage = viewModel.errorMessage {
                // Show error state
                ErrorView(
                    message: errorMessage,
                    onRetry: {
                        Task {
                            await viewModel.loadUserPlans()
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
            await viewModel.loadUserPlans()
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .onAppear {
            startAnimations()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $viewModel.selectedDate,
                isPresented: $showDatePicker
            ) { selectedDate in
                viewModel.selectDate(selectedDate)
            }
        }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView(
                onDismiss: {
                    showAddExercise = false
                },
                onExerciseAdded: { categorizedExercise in
                    Task {
                        await viewModel.addExercise(categorizedExercise)
                    }
                    showAddExercise = false
                }
            )
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

                // Date picker section
                datePickerSection
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                // Plan for selected date
                selectedDatePlanSection

                Spacer(minLength: 0)
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Workout Plans")
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

                Text("Plan and track your workouts")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
        .opacity(headerAppear ? 1 : 0)
        .offset(y: headerAppear ? 0 : -10)
    }

    private var datePickerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Date")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            Button(action: {
                showDatePicker = true
            }) {
                HStack {
                    Text(formattedSelectedDate)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(brandOrange)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
        .opacity(contentAppear ? 1 : 0)
        .offset(y: contentAppear ? 0 : 20)
    }

    private var selectedDatePlanSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Plan for \(formattedSelectedDate)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                if let plan = viewModel.selectedDatePlan {
                    Text("\(plan.completedExercises)/\(plan.totalExercises) completed")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            if let plan = viewModel.selectedDatePlan {
                if plan.exercises.isEmpty {
                    VStack {
                        emptyPlanView
                        addExerciseButton
                    }
                } else {
                    VStack(spacing: 16) {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 12) {
                                ForEach(plan.exercises, id: \.id) { exercise in
                                    WorkoutPlanExerciseCard(planExercise: exercise)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        addExerciseButton
                    }
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            }
        }
        .padding(.horizontal, 20)
        .opacity(contentAppear ? 1 : 0)
        .offset(y: contentAppear ? 0 : 20)
    }

    private var emptyPlanView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))

            Text("No workout planned")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))

            Text("Create a workout plan for this day")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var addExerciseButton: some View {
        Button(action: {
            showAddExercise = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))

                Text("Add Exercise")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(
                LinearGradient(
                    colors: [brandOrange, brandOrange.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(brandOrange.opacity(0.15))
                    .overlay(
                        Capsule()
                            .stroke(brandOrange.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: viewModel.selectedDate)
    }

    private func startAnimations() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
            headerAppear = true
        }

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
            contentAppear = true
        }
    }
}

// MARK: - Workout Plan Exercise Card

struct WorkoutPlanExerciseCard: View {
    let planExercise: TodaysPlanExercise

    var body: some View {
        HStack(spacing: 14) {
            // Exercise info
            VStack(alignment: .leading, spacing: 6) {
                Text(planExercise.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))

                        Text("\(planExercise.sets) sets × \(planExercise.reps) reps")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                if let description = planExercise.description {
                    Text(description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                        .lineLimit(2)
                }
            }

            Spacer()

            // Completion indicator
            ZStack {
                Circle()
                    .fill(planExercise.isCompleted ?
                          Color.green.opacity(0.2) :
                          Color.white.opacity(0.1))
                    .frame(width: 32, height: 32)

                if planExercise.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
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

struct WorkoutPlansLoadingSkeleton: View {
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

                // Date picker skeleton
                VStack(alignment: .leading, spacing: 16) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 100, height: 20)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 44)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                // Plan section skeleton
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 150, height: 24)
                            .cornerRadius(6)
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 80, height: 16)
                            .cornerRadius(4)
                    }

                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 80)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .shimmer()
    }
}

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    let onDateSelected: (Date) -> Void

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()

                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .colorScheme(.dark)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding()

                    Spacer()
                }
            }
            .navigationTitle("Select Workout Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.orange)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDateSelected(selectedDate)
                        isPresented = false
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

#Preview {
    WorkoutPlansView()
        .preferredColorScheme(.dark)
}
