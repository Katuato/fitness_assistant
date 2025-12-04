//
//  ExerciseGridView.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 04.12.2025.
//

import SwiftUI

struct ExerciseGridView: View {
    @ObservedObject var viewModel: AddExerciseViewModel
    let accentGreen: Color
    let brandOrange: Color
    
    var body: some View {
        VStack(spacing: 0) {
            // Back button
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        viewModel.navigateBackToCategories()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("Categories")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(accentGreen)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Exercises grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(viewModel.exercises) { exercise in
                        ExerciseGridCard(
                            exercise: exercise,
                            accentGreen: accentGreen,
                            brandOrange: brandOrange
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                viewModel.selectExercise(exercise)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Bottom spacing
                Color.clear.frame(height: 40)
            }
        }
    }
}

// MARK: - Exercise Grid Card

struct ExerciseGridCard: View {
    let exercise: CategorizedExercise
    let accentGreen: Color
    let brandOrange: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(exercise.category.color.opacity(0.15))
                    
                    Image(systemName: exercise.category.icon)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(exercise.category.color)
                }
                .frame(height: 120)
                
                VStack(alignment: .leading, spacing: 6) {
                    // Exercise name
                    Text(exercise.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Info
                    HStack(spacing: 8) {
                        // Sets x Reps
                        HStack(spacing: 4) {
                            Image(systemName: "repeat")
                                .font(.system(size: 10, weight: .medium))
                            Text("\(exercise.sets)x\(exercise.reps)")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.6))
                        
                        // Difficulty badge
                        Text(exercise.difficulty.rawValue)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(difficultyColor(exercise.difficulty))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(difficultyColor(exercise.difficulty).opacity(0.2))
                            )
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: exercise.category.color.opacity(isPressed ? 0.2 : 0.0),
                radius: isPressed ? 8 : 0,
                y: isPressed ? 4 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func difficultyColor(_ difficulty: ExercisePreviewData.DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner:
            return accentGreen
        case .intermediate:
            return brandOrange
        case .advanced:
            return .red
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        ExerciseGridView(
            viewModel: {
                let vm = AddExerciseViewModel()
                vm.selectedCategory = .biceps
                vm.exercises = CategorizedExercise.exercisesByCategory(.biceps)
                vm.navigationState = .exerciseGrid
                return vm
            }(),
            accentGreen: Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255),
            brandOrange: Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
        )
    }
    .preferredColorScheme(.dark)
}
