//
//  ExerciseCard.swift
//  fitness_assistant
//
//  Changed by andrewfalse on 29.11.2025.
//

import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let onPlayTapped: () -> Void
    let onCardTapped: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    init(exercise: Exercise, onPlayTapped: @escaping () -> Void = {}, onCardTapped: @escaping () -> Void = {}) {
        self.exercise = exercise
        self.onPlayTapped = onPlayTapped
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
                        onPlayTapped()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                exercise.isCompleted
                                    ? Color.white.opacity(0.08)
                                    : accentGreen.opacity(0.2)
                            )
                            .frame(width: 42, height: 42)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(
                                        exercise.isCompleted
                                            ? Color.white.opacity(0.15)
                                            : accentGreen.opacity(0.4),
                                        lineWidth: 1.5
                                    )
                            )
                        
                        Image(systemName: exercise.isCompleted ? "checkmark" : "play.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(exercise.isCompleted ? .white.opacity(0.6) : accentGreen)
                            .scaleEffect(exercise.isCompleted ? 1.0 : 0.9)
                    }
                }
                .buttonStyle(.plain)
                
                // Exercise Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(exercise.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "repeat")
                            .font(.system(size: 10, weight: .medium))
                        
                        Text("\(exercise.sets) sets • \(exercise.reps) reps")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Accuracy Display
                if let accuracy = exercise.accuracy {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "target")
                                .font(.system(size: 11, weight: .medium))
                            
                            Text("\(accuracy)%")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(brandOrange)
                        
                        Text("accuracy")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                    }
                } else {
                    VStack(spacing: 4) {
                        Text("—")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.4))
                        
                        Text("no data")
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
                exercise: Exercise(
                    name: "Squats",
                    sets: 3,
                    reps: 12,
                    accuracy: 94,
                    isCompleted: false
                )
            )
            
            ExerciseCard(
                exercise: Exercise(
                    name: "Deadlifts",
                    sets: 4,
                    reps: 8,
                    accuracy: 89,
                    isCompleted: true
                )
            )
            
            ExerciseCard(
                exercise: Exercise(
                    name: "Bench Press",
                    sets: 4,
                    reps: 10,
                    accuracy: nil,
                    isCompleted: false
                )
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
