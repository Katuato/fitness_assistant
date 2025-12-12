//
//  DashboardView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var headerAppear = false
    @State private var chartAppear = false
    @State private var sessionsAppear = false
    
    // Consistent padding for all elements
    private let horizontalPadding: CGFloat = 20
    
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
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Track your progress")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.55))
                            
                            Text("Performance Dashboard")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 70)
                        .padding(.horizontal, horizontalPadding)
                        .opacity(headerAppear ? 1 : 0)
                        .offset(y: headerAppear ? 0 : -20)
                        
                        // Weekly Accuracy Chart
                        if let stats = viewModel.weeklyStats {
                            WeeklyAccuracyChart(
                                stats: stats,
                                brandPurple: brandPurple,
                                brandOrange: brandOrange,
                                accentGreen: accentGreen
                            )
                            .padding(.horizontal, horizontalPadding)
                            .opacity(chartAppear ? 1 : 0)
                            .offset(y: chartAppear ? 0 : 20)
                        }
                        
                        // Recent Training Sessions
                        if !viewModel.recentSessions.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Recent Training")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        print("View all sessions tapped")
                                    }) {
                                        Text("View All")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(brandOrange)
                                    }
                                }
                                
                                ForEach(Array(viewModel.recentSessions.prefix(3).enumerated()), id: \.element.id) { index, session in
                                    TrainingSessionCard(
                                        session: session,
                                        accentGreen: accentGreen,
                                        brandOrange: brandOrange
                                    )
                                    .opacity(sessionsAppear ? 1 : 0)
                                    .offset(x: sessionsAppear ? 0 : 50)
                                    .animation(
                                        .spring(response: 0.6, dampingFraction: 0.8)
                                            .delay(Double(index) * 0.1),
                                        value: sessionsAppear
                                    )
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
                
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.2)
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.loadData()
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            headerAppear = true
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
            chartAppear = true
        }
        
        withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
            sessionsAppear = true
        }
    }
}

// MARK: - Weekly Accuracy Chart Component

struct WeeklyAccuracyChart: View {
    let stats: WeeklyStats
    let brandPurple: Color
    let brandOrange: Color
    let accentGreen: Color
    
    @State private var selectedDay: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text(stats.weekLabel)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(stats.formattedAccuracy)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(accentGreen)
                    
                    Text("Avg Accuracy")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Chart
            Chart(stats.dailyAccuracies) { dayData in
                BarMark(
                    x: .value("Day", dayData.day),
                    y: .value("Accuracy", dayData.accuracy)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [brandPurple, brandOrange.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(8)
                .opacity(selectedDay == nil || selectedDay == dayData.day ? 1.0 : 0.4)
            }
            .frame(height: 180)
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [0, 25, 50, 75, 100]) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)%")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 4]))
                        .foregroundStyle(.white.opacity(0.1))
                }
            }
            .chartYScale(domain: 0...100)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.clear)
            }
            .chartXSelection(value: $selectedDay)
            
            // Selected day info
            if let selectedDayName = selectedDay,
               let selected = stats.dailyAccuracies.first(where: { $0.day == selectedDayName }) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(brandPurple)
                        .frame(width: 8, height: 8)
                    
                    Text(selected.day)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text("\(Int(selected.accuracy))%")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(accentGreen)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.03))
                
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
        )
    }
}

// MARK: - Training Session Card

struct TrainingSessionCard: View {
    let session: WorkoutSession
    let accentGreen: Color
    let brandOrange: Color
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            // Handle tap
            print("Session tapped: \(session.id)")
        }) {
            HStack(spacing: 14) {
                // Left side icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    brandOrange.opacity(0.3),
                                    brandOrange.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(brandOrange)
                }
                
                // Middle content
                VStack(alignment: .leading, spacing: 6) {
                    Text(session.bodyPart)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                            
                            Text("\(session.exerciseCount) exercises")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Text("•")
                            .foregroundColor(.white.opacity(0.3))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                            
                            Text("\(session.totalTime) min")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    Text(session.formattedDate)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.45))
                }
                
                Spacer(minLength: 0)
                
                // Right side chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(isHovered ? 0.08 : 0.05))
                    
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                }
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = pressing
            }
        }, perform: {})
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}

