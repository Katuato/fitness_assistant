//
//  ExerciseDetailView.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 04.12.2025.
//

import SwiftUI

struct ExerciseDetailView: View {
    @ObservedObject var viewModel: AddExerciseViewModel
    let accentGreen: Color
    let brandOrange: Color
    let onAddExercise: (CategorizedExercise) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Back button
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        viewModel.navigateBackToGrid()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(accentGreen)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 8)
            
            // Scrollable content (same structure as ExercisePreviewView)
            ScrollView(showsIndicators: false) {
                if let exercise = viewModel.selectedExercise {
                    VStack(spacing: 24) {
                        // Header with exercise name
                        headerSection(exercise: exercise)
                        
                        // Video/Image placeholder (same as ExercisePreviewView)
                        videoSection(exercise: exercise)
                        
                        // Exercise info pills
                        infoSection(exercise: exercise)
                        
                        // Target muscles
                        musclesSection(exercise: exercise)
                        
                        // Description
                        descriptionSection(exercise: exercise)
                        
                        // Instructions
                        instructionsSection(exercise: exercise)
                        
                        // Bottom spacing for button
                        Color.clear.frame(height: 120)
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
            
            // Fixed bottom button
            if let exercise = viewModel.selectedExercise {
                bottomButton(exercise: exercise)
            }
        }
    }
    
    // MARK: - Header Section
    
    private func headerSection(exercise: CategorizedExercise) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(exercise.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                Label("\(exercise.sets)×\(exercise.reps)", systemImage: "repeat")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Label("\(exercise.estimatedDuration) min", systemImage: "clock")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Label("\(exercise.caloriesBurn) kcal", systemImage: "flame")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(brandOrange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Video Section (same as ExercisePreviewView)
    
    private func videoSection(exercise: CategorizedExercise) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accentGreen.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(accentGreen)
                }
                
                Text("Watch Tutorial")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(height: 200)
    }
    
    // MARK: - Info Section (pills like ExercisePreviewView)
    
    private func infoSection(exercise: CategorizedExercise) -> some View {
        HStack(spacing: 12) {
            InfoPill(
                icon: "chart.bar.fill",
                text: exercise.difficulty.rawValue,
                color: difficultyColor(exercise.difficulty)
            )
            
            InfoPill(
                icon: "figure.strengthtraining.traditional",
                text: "Strength",
                color: accentGreen
            )
            
            InfoPill(
                icon: "flame.fill",
                text: "\(exercise.caloriesBurn) kcal",
                color: brandOrange
            )
        }
    }
    
    // MARK: - Muscles Section (white pills like ExercisePreviewView)
    
    private func musclesSection(exercise: CategorizedExercise) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Muscles")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            FlowLayout(spacing: 8) {
                ForEach(exercise.targetMuscles, id: \.self) { muscle in
                    MusclePill(name: muscle)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Description Section
    
    private func descriptionSection(exercise: CategorizedExercise) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(exercise.description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Instructions Section
    
    private func instructionsSection(exercise: CategorizedExercise) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Perform")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                    InstructionRow(
                        number: index + 1,
                        text: instruction,
                        accentColor: accentGreen
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Bottom Button
    
    private func bottomButton(exercise: CategorizedExercise) -> some View {
        VStack(spacing: 0) {
            // Gradient fade
            LinearGradient(
                colors: [
                    Color.customBackground.opacity(0),
                    Color.customBackground
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 30)
            
            Button(action: {
                onAddExercise(exercise)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Add to Plan")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(accentGreen)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(Color.customBackground)
        }
    }
    
    // MARK: - Helper
    
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
        
        ExerciseDetailView(
            viewModel: {
                let vm = AddExerciseViewModel()
                vm.selectedCategory = .biceps
                vm.selectedExercise = CategorizedExercise.bicepCurl
                vm.navigationState = .exerciseDetail
                return vm
            }(),
            accentGreen: Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255),
            brandOrange: Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255),
            onAddExercise: { _ in }
        )
    }
    .preferredColorScheme(.dark)
}
