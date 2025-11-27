//
//  ExerciseCard.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let onPlayTapped: () -> Void
    
    init(exercise: Exercise, onPlayTapped: @escaping () -> Void = {}) {
        self.exercise = exercise
        self.onPlayTapped = onPlayTapped
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onPlayTapped) {
                Image(systemName: "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(exercise.isCompleted ? .gray : .green)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(exercise.isCompleted ? Color.gray : Color.green, lineWidth: 2)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(exercise.sets) sets x \(exercise.reps) reps")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let accuracy = exercise.accuracy {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(accuracy)%")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("accuracy")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

#Preview {
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
                sets: 3,
                reps: 8,
                accuracy: nil,
                isCompleted: false
            )
        )
    }
    .padding()
    .background(Color.customBackground)
    .preferredColorScheme(.dark)
}
