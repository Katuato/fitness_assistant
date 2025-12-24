//
//  ExerciseCard.swift
//  fitness_assistant
//
//  Changed by andrewfalse on 29.11.2025.
//

import SwiftUI

struct ExerciseCard: View {
    let planExercise: TodaysPlanExercise
    let onPlayTapped: () -> Void
    let onCompleteTapped: () -> Void
    let onCardTapped: () -> Void

    @State private var isPressed = false
    @State private var isHovered = false

    init(planExercise: TodaysPlanExercise, onPlayTapped: @escaping () -> Void = {}, onCompleteTapped: @escaping () -> Void = {}, onCardTapped: @escaping () -> Void = {}) {
        self.planExercise = planExercise
        self.onPlayTapped = onPlayTapped
        self.onCompleteTapped = onCompleteTapped
        self.onCardTapped = onCardTapped
    }

    // Для обратной совместимости
    init(exercise: Exercise, onPlayTapped: @escaping () -> Void = {}, onCardTapped: @escaping () -> Void = {}, exerciseId: Int? = nil) {
        self.planExercise = TodaysPlanExercise(
            id: 0, // dummy id
            exerciseId: exerciseId ?? 0, // dummy exerciseId
            name: exercise.name,
            sets: exercise.sets,
            reps: exercise.reps,
            isCompleted: exercise.isCompleted,
            description: nil,
            difficulty: nil,
            targetMuscles: [],
            imageUrl: nil
        )
        self.onPlayTapped = onPlayTapped
        self.onCompleteTapped = {} // не используется для старого API
        self.onCardTapped = onCardTapped
    }
    
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
                onCardTapped()
            }
        }) {
            HStack(spacing: 14) {
                // Play/Check Button
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        if planExercise.isCompleted {
                            onCompleteTapped() // Toggle completion for completed exercises
                        } else {
                            onPlayTapped() // Start exercise for incomplete exercises
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                planExercise.isCompleted
                                    ? Color.white.opacity(0.08)
                                    : accentGreen.opacity(0.2)
                            )
                            .frame(width: 42, height: 42)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(
                                        planExercise.isCompleted
                                            ? Color.white.opacity(0.15)
                                            : accentGreen.opacity(0.4),
                                        lineWidth: 1.5
                                    )
                            )

                        Image(systemName: planExercise.isCompleted ? "checkmark" : "play.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(planExercise.isCompleted ? .white.opacity(0.6) : accentGreen)
                            .scaleEffect(planExercise.isCompleted ? 1.0 : 0.9)
                    }
                }
                .buttonStyle(.plain)
                
                // Exercise Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(planExercise.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "repeat")
                            .font(.system(size: 10, weight: .medium))

                        Text("\(planExercise.sets) sets • \(planExercise.reps) reps")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.6))

                    // Description
                    if let description = planExercise.description, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    // Target Muscles Tags
                    if !planExercise.targetMuscles.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(planExercise.targetMuscles.prefix(2), id: \.self) { muscle in
                                Text(muscle)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(brandOrange)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(brandOrange.opacity(0.1))
                                    )
                            }

                            if planExercise.targetMuscles.count > 2 {
                                Text("+\(planExercise.targetMuscles.count - 2)")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding(.top, 2)
                    }
                }

                Spacer()

                // Difficulty Display
                if let difficulty = planExercise.difficulty {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 11, weight: .medium))

                            Text(difficulty.prefix(3).uppercased())
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(brandOrange)

                        Text("level")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                    }
                } else {
                    VStack(spacing: 4) {
                        Text("—")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.4))

                        Text("level")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                            .textCase(.uppercase)
                    }
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
                    .offset(x: isPressed ? 4 : 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                Color.white.opacity(isPressed ? 0.2 : 0.12),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: Color.black.opacity(isPressed ? 0.2 : 0.1),
                radius: isPressed ? 10 : 5,
                x: 0,
                y: isPressed ? 5 : 2
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()

        VStack(spacing: 16) {
            ExerciseCard(
                planExercise: TodaysPlanExercise(
                    id: 1,
                    exerciseId: 4, // Squats
                    name: "Squats",
                    sets: 3,
                    reps: 12,
                    isCompleted: false,
                    description: "A basic lower body exercise",
                    difficulty: "intermediate",
                    targetMuscles: ["Quadriceps", "Glutes"],
                    imageUrl: nil
                )
            )

            ExerciseCard(
                planExercise: TodaysPlanExercise(
                    id: 2,
                    exerciseId: 5, // Deadlifts
                    name: "Deadlifts",
                    sets: 4,
                    reps: 8,
                    isCompleted: true,
                    description: "A compound full body exercise",
                    difficulty: "advanced",
                    targetMuscles: ["Back", "Legs"],
                    imageUrl: nil
                )
            )

            ExerciseCard(
                planExercise: TodaysPlanExercise(
                    id: 3,
                    exerciseId: 3, // Bench Press
                    name: "Bench Press",
                    sets: 4,
                    reps: 10,
                    isCompleted: false,
                    description: "A chest exercise",
                    difficulty: "intermediate",
                    targetMuscles: ["Chest", "Triceps"],
                    imageUrl: nil
                )
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
