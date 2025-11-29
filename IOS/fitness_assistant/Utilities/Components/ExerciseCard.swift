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
    
    init(exercise: Exercise, onPlayTapped: @escaping () -> Void = {}) {
        self.exercise = exercise
        self.onPlayTapped = onPlayTapped
    }
    
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Button(action: onPlayTapped) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(accentGreen.opacity(exercise.isCompleted ? 0.1 : 0.2))
                        .frame(width: 38, height: 38)
                    
                    Image(systemName: exercise.isCompleted ? "checkmark" : "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(exercise.isCompleted ? .gray : accentGreen)
                }
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(exercise.sets) sets • \(exercise.reps) reps")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(exercise.sets)x")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(brandOrange)
                
                if let accuracy = exercise.accuracy {
                    Text("\(accuracy)%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(brandOrange)
                } else {
                    Text("—")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        VStack(spacing: 12) {
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
                    accuracy: nil,
                    isCompleted: false
                )
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
