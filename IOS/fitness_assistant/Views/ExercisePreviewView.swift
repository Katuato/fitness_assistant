//
//  ExercisePreviewView.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 02.12.2025.
//

import SwiftUI

struct ExercisePreviewView: View {
    let exercise: Exercise?
    let planExercise: TodaysPlanExercise?
    let onDismiss: () -> Void
    let onStartTracking: () -> Void
    let onRemove: (() -> Void)?
    let onToggleComplete: (() -> Void)?

    init(exercise: Exercise, onDismiss: @escaping () -> Void, onStartTracking: @escaping () -> Void) {
        self.exercise = exercise
        self.planExercise = nil
        self.onDismiss = onDismiss
        self.onStartTracking = onStartTracking
        self.onRemove = nil
        self.onToggleComplete = nil
    }

    init(planExercise: TodaysPlanExercise, onDismiss: @escaping () -> Void, onStartTracking: @escaping () -> Void, onRemove: (() -> Void)? = nil, onToggleComplete: (() -> Void)? = nil) {
        self.exercise = nil
        self.planExercise = planExercise
        self.onDismiss = onDismiss
        self.onStartTracking = onStartTracking
        self.onRemove = onRemove
        self.onToggleComplete = onToggleComplete
    }
    
    @StateObject private var viewModel = ExercisePreviewViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var isPresented = false  // For animation control
    
    private let dismissThreshold: CGFloat = 200
    
    // MARK: - Brand Colors
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    // MARK: - Computed Properties
    
    /// Calculate blur radius based on drag offset (0 when closed, 20 when fully open)
    private var blurRadius: CGFloat {
        let progress = max(0, min(1, 1 - (dragOffset / UIScreen.main.bounds.height)))
        return progress * 20
    }
    
    /// Calculate dimming opacity
    private var dimmingOpacity: Double {
        let progress = max(0, min(1, 1 - (dragOffset / UIScreen.main.bounds.height)))
        return progress * 0.4
    }
    
    /// Calculate sheet offset
    private var sheetOffset: CGFloat {
        if isPresented {
            return max(0, dragOffset)
        } else {
            // Start offscreen at the bottom
            return UIScreen.main.bounds.height
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dimming overlay with blur
                Color.black
                    .opacity(dimmingOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissWithAnimation()
                    }
                
                // Sheet content
                VStack(spacing: 0) {
                    Spacer()
                    
                    sheetContent(geometry: geometry)
                        .offset(y: sheetOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    if value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    isDragging = false
                                    if dragOffset > dismissThreshold {
                                        dismissWithAnimation()
                                    } else {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            // Animate in with spring animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                isPresented = true
            }
        }
        .task {
            if let planExercise = planExercise {
                await viewModel.loadExercisePreview(for: planExercise)
                viewModel.trackPreviewViewed(exerciseId: UUID()) // dummy UUID for now
            } else if let exercise = exercise {
                await viewModel.loadExercisePreview(for: exercise)
                viewModel.trackPreviewViewed(exerciseId: exercise.id)
            }
        }
    }
    
    // MARK: - Sheet Content
    
    @ViewBuilder
    private func sheetContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Handle bar
            handleBar()
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            // Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header with close button
                    headerSection()
                    
                    // Video placeholder
                    videoSection()
                    
                    // Exercise info
                    if let data = viewModel.previewData {
                        infoSection(data: data)
                        musclesSection(muscles: data.targetMuscles)
                        descriptionSection(description: data.description)
                        instructionsSection(instructions: data.instructions)
                    } else if viewModel.isLoading {
                        loadingSection()
                    }
                    
                    // Bottom spacing for button
                    Color.clear.frame(height: 120)
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Fixed bottom button
            bottomButton()
        }
        .frame(maxWidth: .infinity)
        .frame(height: geometry.size.height * 0.95) // Extend closer to bottom
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.customBackground)
                .shadow(color: .black.opacity(0.3), radius: 30, y: -10)
                .ignoresSafeArea(edges: .bottom) // Extend to screen bottom
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    // MARK: - Handle Bar
    
    private func handleBar() -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.white.opacity(0.3))
            .frame(width: 40, height: 5)
            .padding(.vertical, 8)
    }
    
    // MARK: - Header Section
    
    private func headerSection() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(planExercise?.name ?? exercise?.name ?? "Unknown Exercise")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                if let data = viewModel.previewData {
                    HStack(spacing: 12) {
                        Label("\(data.exercise.sets)x\(data.exercise.reps)", systemImage: "repeat")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Label("\(data.estimatedDuration) min", systemImage: "clock")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Label("\(data.caloriesBurn) kcal", systemImage: "flame")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(brandOrange)
                    }
                }
            }
            
            Spacer()

            // Action buttons for plan exercises
            if planExercise != nil {
                HStack(spacing: 12) {
                    if let onToggleComplete = onToggleComplete {
                        Button(action: onToggleComplete) {
                            Image(systemName: planExercise?.isCompleted == true ? "checkmark.circle.fill" : "checkmark.circle")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(planExercise?.isCompleted == true ? accentGreen : .white.opacity(0.6))
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(planExercise?.isCompleted == true ? accentGreen.opacity(0.2) : Color.white.opacity(0.1))
                                )
                        }
                    }

                    if let onRemove = onRemove {
                        Button(action: onRemove) {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.red.opacity(0.8))
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color.red.opacity(0.1))
                                )
                        }
                    }

                    Button(action: dismissWithAnimation) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }
            } else {
                Button(action: dismissWithAnimation) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
        }
    }
    
    // MARK: - Video Section
    
    private func videoSection() -> some View {
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
    
    // MARK: - Info Section
    
    private func infoSection(data: ExercisePreviewData) -> some View {
        HStack(spacing: 12) {
            InfoPill(
                icon: "chart.bar.fill",
                text: data.difficulty.rawValue,
                color: .blue
            )
            
            InfoPill(
                icon: "figure.strengthtraining.traditional",
                text: "Strength",
                color: accentGreen
            )
            
            if let accuracy = data.exercise.accuracy {
                InfoPill(
                    icon: "target",
                    text: "\(accuracy)%",
                    color: brandOrange
                )
            }
        }
    }
    
    // MARK: - Muscles Section
    
    private func musclesSection(muscles: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Muscles")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            FlowLayout(spacing: 8) {
                ForEach(muscles, id: \.self) { muscle in
                    MusclePill(name: muscle)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Description Section
    
    private func descriptionSection(description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Instructions Section
    
    private func instructionsSection(instructions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Perform")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                    InstructionRow(number: index + 1, text: instruction)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Loading Section
    
    private func loadingSection() -> some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(accentGreen)
            
            Text("Loading exercise details...")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Bottom Button
    
    private func bottomButton() -> some View {
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
            
            Button(action: handleStartTracking) {
                HStack(spacing: 8) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Start AI Tracking")
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
    
    // MARK: - Actions
    
    private func dismissWithAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isPresented = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onDismiss()
        }
    }
    
    private func handleStartTracking() {
        viewModel.trackStartAITracking(exerciseId: exercise?.id ?? UUID())
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isPresented = false
        }
        
        // Delay to allow dismiss animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onStartTracking()
        }
    }
}

// MARK: - Supporting Views

struct InfoPill: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            
            Text(text)
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
        )
    }
}

struct MusclePill: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
    }
}

struct InstructionRow: View {
    let number: Int
    let text: String
    var accentColor: Color = Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(accentColor.opacity(0.2))
                )
            
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(3)
            
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Flow Layout for Pills

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize
        var positions: [CGPoint]
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var positions: [CGPoint] = []
            var size: CGSize = .zero
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)
                
                if currentX + subviewSize.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, subviewSize.height)
                currentX += subviewSize.width + spacing
                size.width = max(size.width, currentX - spacing)
            }
            
            size.height = currentY + lineHeight
            self.size = size
            self.positions = positions
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        ExercisePreviewView(
            exercise: Exercise(
                name: "Squats",
                sets: 3,
                reps: 12,
                accuracy: 94,
                isCompleted: false
            ),
            onDismiss: {},
            onStartTracking: {}
        )
    }
    .preferredColorScheme(.dark)
}
