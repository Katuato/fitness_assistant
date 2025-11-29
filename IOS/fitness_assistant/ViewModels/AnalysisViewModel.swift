//
//  AnalysisViewModel.swift.swift
//  fitness_assistant
//
//  Created by Andrew Novoseltsev on 28.11.2025.
//

import Foundation
import SwiftUI

@MainActor
final class AnalysisViewModel: ObservableObject {
    @Published var stats: AnalysisStats
    @Published var suggestedExercises: [AnalysisExercise]
    
    // Состояние
    @Published var isRecording: Bool = false
    @Published var isAnalyzing: Bool = false
    @Published var errorMessage: String?
    
    // Анимация градиента в углах
    @Published var gradientRotation: Double = 0.0
    
    private var gradientTimer: Timer?
    
    init(
        stats: AnalysisStats = AnalysisMockData.stats,
        suggestedExercises: [AnalysisExercise] = AnalysisMockData.exercises
    ) {
        self.stats = stats
        self.suggestedExercises = suggestedExercises
        startGradientAnimation()
    }
    
    nonisolated deinit {
        Task { @MainActor [weak gradientTimer] in
            gradientTimer?.invalidate()
        }
    }
    
    // MARK: - Computed
    
    var formattedTime: String {
        let minutes = stats.timeSeconds / 60
        let seconds = stats.timeSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - Gradient Animation (медленное вращение по часовой)
    
    private func startGradientAnimation() {
        gradientTimer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                withAnimation(.linear(duration: 0.025)) {
                    self.gradientRotation += 0.18
                    if self.gradientRotation >= 360 {
                        self.gradientRotation = 0
                    }
                }
            }
        }
        
        if let timer = gradientTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func stopGradientAnimation() {
        gradientTimer?.invalidate()
        gradientTimer = nil
    }
    
    // MARK: - Intents
    
    func toggleRecording() {
        isRecording.toggle()
        isAnalyzing = isRecording
    }
    
    func viewAllExercises() {
        // навигация/логика "View All"
        print("View all exercises")
    }
    
    func selectExercise(_ exercise: AnalysisExercise) {
        print("Selected exercise: \(exercise.name)")
    }
}
