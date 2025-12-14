//
//  ShimmerEffect.swift
//  fitness_assistant
//
//  Created by andrewfalse on 12.12.2025.
//

import SwiftUI

// MARK: - Shimmer Modifier

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    var duration: Double = 1.5
    var bounce: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.clear, location: 0),
                                    .init(color: Color.white.opacity(0.15), location: 0.4),
                                    .init(color: Color.white.opacity(0.25), location: 0.5),
                                    .init(color: Color.white.opacity(0.15), location: 0.6),
                                    .init(color: Color.clear, location: 1)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .blur(radius: 8)
                        .rotationEffect(.degrees(0))
                        .offset(x: -geometry.size.width + (2 * geometry.size.width * phase))
                        .onAppear {
                            withAnimation(
                                .linear(duration: duration)
                                    .repeatForever(autoreverses: false)
                            ) {
                                phase = 1
                            }
                        }
                }
            )
            .clipped()
    }
}

extension View {
    func shimmer(duration: Double = 1.5, bounce: Bool = false) -> some View {
        modifier(ShimmerEffect(duration: duration, bounce: bounce))
    }
}

// MARK: - Shimmer Loading Views

struct ShimmerHeaderSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .frame(width: 120, height: 18)
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.12))
                .frame(width: 220, height: 38)
                .shimmer(duration: 2.0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ShimmerStatCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white.opacity(0.12))
                .frame(width: 50, height: 28)
            
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .frame(width: 70, height: 14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .shimmer(duration: 2.2)
    }
}

struct ShimmerExerciseCardSkeleton: View {
    var body: some View {
        HStack(spacing: 14) {
            // Play button skeleton
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .frame(width: 42, height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                )
            
            // Exercise info skeleton
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 140, height: 16)
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 100, height: 12)
            }
            
            Spacer()
            
            // Accuracy skeleton
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 50, height: 16)
                
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 45, height: 10)
            }
            
            // Chevron skeleton
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 16, height: 16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .shimmer(duration: 2.5)
    }
}

struct ShimmerPlanHeaderSkeleton: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 160, height: 28)
                
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 100, height: 14)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .frame(width: 100, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        }
    }
}

// MARK: - Complete Loading Skeleton

struct HomeViewLoadingSkeleton: View {
    private var brandPurple: Color {
        Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    @State private var gradientRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Animated background
            ZStack {
                Image("page_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // Header skeleton
                ShimmerHeaderSkeleton()
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 24)
                
                // Stats section skeleton
                HStack(spacing: 12) {
                    ShimmerStatCardSkeleton()
                    ShimmerStatCardSkeleton()
                    ShimmerStatCardSkeleton()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                
                // Today's Plan section
                VStack(alignment: .leading, spacing: 0) {
                    ShimmerPlanHeaderSkeleton()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    // Scrollable exercises list skeleton
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(0..<4, id: \.self) { index in
                                ShimmerExerciseCardSkeleton()
                                    .opacity(1.0 - (Double(index) * 0.1))
                            }
                            
                            // Add exercise button skeleton
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color.white.opacity(0.04))
                                    .frame(width: 28, height: 28)
                                
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.white.opacity(0.06))
                                    .frame(width: 110, height: 16)
                                
                                Spacer()
                                
                                Circle()
                                    .fill(Color.white.opacity(0.04))
                                    .frame(width: 16, height: 16)
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.white.opacity(0.02))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                    )
                            )
                            .opacity(0.6)
                            
                            Color.clear.frame(height: 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    HomeViewLoadingSkeleton()
        .preferredColorScheme(.dark)
}
