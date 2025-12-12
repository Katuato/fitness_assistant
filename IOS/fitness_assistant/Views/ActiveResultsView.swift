//
//  ActiveResultsView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 12.12.2025.
//

import SwiftUI

struct ActiveResultsView: View {
    let onDismiss: () -> Void
    
    @State private var isLoading = true
    @State private var isPresented = false
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var processingProgress: CGFloat = 0
    
    private let dismissThreshold: CGFloat = 200
    
    // MARK: - Brand Colors
    
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    private var brandPurple: Color {
        Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255)
    }
    
    // MARK: - Computed Properties
    
    private var dimmingOpacity: Double {
        if isLoading {
            return 0.6
        }
        let progress = max(0, min(1, 1 - (dragOffset / UIScreen.main.bounds.height)))
        return progress * 0.4
    }
    
    private var sheetOffset: CGFloat {
        if isLoading {
            return UIScreen.main.bounds.height
        }
        if isPresented {
            return max(0, dragOffset)
        } else {
            return UIScreen.main.bounds.height
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dimming overlay
                Color.black
                    .opacity(dimmingOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if !isLoading {
                            dismissWithAnimation()
                        }
                    }
                
                // Loading view
                if isLoading {
                    loadingView
                        .transition(.opacity)
                }
                
                // Results sheet
                VStack(spacing: 0) {
                    Spacer()
                    
                    resultsSheetContent(geometry: geometry)
                        .offset(y: sheetOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !isLoading {
                                        isDragging = true
                                        if value.translation.height > 0 {
                                            dragOffset = value.translation.height
                                        }
                                    }
                                }
                                .onEnded { value in
                                    if !isLoading {
                                        isDragging = false
                                        if dragOffset > dismissThreshold {
                                            dismissWithAnimation()
                                        } else {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                dragOffset = 0
                                            }
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
            startProcessing()
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            // Processing animation
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: processingProgress)
                    .stroke(
                        LinearGradient(
                            colors: [brandOrange, brandOrange.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 3), value: processingProgress)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(brandOrange)
                    .scaleEffect(processingProgress > 0.5 ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: processingProgress)
            }
            
            VStack(spacing: 8) {
                Text("Analyzing Your Form")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("AI is processing your workout...")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Progress text
            Text("\(Int(processingProgress * 100))%")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(brandOrange)
                .monospacedDigit()
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 40)
    }
    
    // MARK: - Results Sheet Content
    
    private func resultsSheetContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            // Header
            HStack {
                Text("Analysis Results")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: dismissWithAnimation) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Video fragment placeholder
                    videoFragmentSection
                    
                    // Accuracy score
                    accuracyScoreSection
                    
                    // Good points
                    goodPointsSection
                    
                    // Mistakes to work on
                    mistakesSection
                    
                    // Bottom spacing
                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(height: geometry.size.height * 0.75)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.customBackground)
                .ignoresSafeArea(edges: .bottom)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -5)
    }
    
    // MARK: - Video Fragment Section
    
    private var videoFragmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recorded Session")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                VStack(spacing: 16) {
                    // Video thumbnail placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        brandPurple.opacity(0.3),
                                        brandOrange.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 180)
                        
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 64, height: 64)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Duration
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12, weight: .medium))
                        
                        Text("0:45")
                            .font(.system(size: 14, weight: .semibold))
                            .monospacedDigit()
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("12 reps")
                                .font(.system(size: 14, weight: .medium))
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                            
                            Text("3 sets")
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 4)
                }
                .padding(16)
            }
        }
    }
    
    // MARK: - Accuracy Score Section
    
    private var accuracyScoreSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 12)
                    .frame(width: 140, height: 140)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: 0.87) // 87% accuracy
                    .stroke(
                        LinearGradient(
                            colors: [accentGreen, accentGreen.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("87%")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(accentGreen)
                    
                    Text("Accuracy")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - Good Points Section
    
    private var goodPointsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(accentGreen)
                
                Text("What You Did Great")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 10) {
                FeedbackRow(
                    icon: "checkmark.circle.fill",
                    text: "Excellent back posture throughout the movement",
                    color: accentGreen
                )
                
                FeedbackRow(
                    icon: "checkmark.circle.fill",
                    text: "Controlled tempo on both eccentric and concentric phases",
                    color: accentGreen
                )
                
                FeedbackRow(
                    icon: "checkmark.circle.fill",
                    text: "Proper breathing technique maintained",
                    color: accentGreen
                )
            }
        }
    }
    
    // MARK: - Mistakes Section
    
    private var mistakesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(brandOrange)
                
                Text("Areas to Improve")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 10) {
                FeedbackRow(
                    icon: "exclamationmark.circle.fill",
                    text: "Elbows slightly flared out during lowering phase",
                    color: brandOrange
                )
                
                FeedbackRow(
                    icon: "exclamationmark.circle.fill",
                    text: "Range of motion could be deeper on some reps",
                    color: brandOrange
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func startProcessing() {
        withAnimation(.easeInOut(duration: 3)) {
            processingProgress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                isLoading = false
                isPresented = true
            }
        }
    }
    
    private func dismissWithAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isPresented = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

// MARK: - Supporting Views

struct ScorePill: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(value)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct FeedbackRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        ActiveResultsView(onDismiss: {})
    }
    .preferredColorScheme(.dark)
}
