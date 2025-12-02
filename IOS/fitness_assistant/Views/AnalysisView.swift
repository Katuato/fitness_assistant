//
//  AnalysisView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    @State private var selectedExerciseForPreview: Exercise?
    
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
            // Main content with conditional blur
            ZStack {
                Color.customBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Real-time form correction")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.55))
                        
                        Text("AI Posture Tracker")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    AnalysisCameraCard(
                        gradientRotation: viewModel.gradientRotation,
                        brandPurple: brandPurple,
                        brandOrange: brandOrange,
                        isRecording: viewModel.isRecording,
                        toggleRecording: viewModel.toggleRecording
                    )
                    .padding(.horizontal, 16)
                    
                    HStack(spacing: 12) {
                        MetricCard(title: "Reps", value: "\(viewModel.stats.reps)")
                        MetricCard(title: "Sets", value: "\(viewModel.stats.sets)")
                        MetricCard(title: "Time", value: viewModel.formattedTime)
                    }
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Text("Suggested Exercises")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: viewModel.viewAllExercises) {
                            Text("View All")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(brandOrange)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: 10) {
                        ForEach(viewModel.suggestedExercises.prefix(2)) { exercise in
                            ExerciseRow(
                                exercise: exercise,
                                accentGreen: accentGreen,
                                action: { 
                                    // Convert AnalysisExercise to Exercise for preview
                                    let exerciseForPreview = Exercise(
                                        name: exercise.name,
                                        sets: 3,
                                        reps: 12,
                                        accuracy: nil,
                                        isCompleted: false
                                    )
                                    selectedExerciseForPreview = exerciseForPreview
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 40)
                }
            }
            .blur(radius: selectedExerciseForPreview != nil ? 10 : 0)
            .animation(.easeInOut(duration: 0.3), value: selectedExerciseForPreview != nil)
            
            // Exercise Preview Sheet (NOT blurred)
            if let exercise = selectedExerciseForPreview {
                ExercisePreviewView(
                    exercise: exercise,
                    onDismiss: {
                        selectedExerciseForPreview = nil
                    },
                    onStartTracking: {
                        // Already on Analysis view, just dismiss
                        selectedExerciseForPreview = nil
                        viewModel.isRecording = true
                    }
                )
                .zIndex(999)
                .ignoresSafeArea()
            }
        }
    }
}

struct AnalysisCameraCard: View {
    let gradientRotation: Double
    let brandPurple: Color
    let brandOrange: Color
    let isRecording: Bool
    let toggleRecording: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.03))
            
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        brandPurple.opacity(0.95),
                        brandPurple.opacity(0.0)
                    ]),
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 260
                )
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        brandOrange.opacity(0.95),
                        brandOrange.opacity(0.0)
                    ]),
                    center: .bottomTrailing,
                    startRadius: 0,
                    endRadius: 260
                )
            }
            .rotationEffect(.degrees(gradientRotation))
            .blur(radius: 30)
            .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    .blendMode(.screen)
            )
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            Color.white.opacity(0.5),
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 6])
                        )
                        .frame(width: 96, height: 96)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                }
                
                Text("Position yourself in frame")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Button(action: toggleRecording) {
                    HStack(spacing: 8) {
                        Image(systemName: isRecording ? "stop.fill" : "video.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text(isRecording ? "Stop Recording" : "Start Tracking")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.18))
                    )
                    .foregroundColor(.white)
                }
                .padding(.top, 4)
            }
            .padding(32)
        }
        .frame(height: 260)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

struct ExerciseRow: View {
    let exercise: AnalysisExercise
    let accentGreen: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(accentGreen.opacity(0.2))
                        .frame(width: 38, height: 38)
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(accentGreen)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(exercise.level) • \(exercise.durationSeconds / 60) min")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    AnalysisView()
        .preferredColorScheme(.dark)
}
