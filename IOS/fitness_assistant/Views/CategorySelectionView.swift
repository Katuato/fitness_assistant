//
//  CategorySelectionView.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 04.12.2025.
//

import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: AddExerciseViewModel
    let accentGreen: Color
    let brandOrange: Color
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Description
                Text("Choose a category to find exercises that match your workout goals")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                // Categories Grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(
                            category: category,
                            accentGreen: accentGreen,
                            brandOrange: brandOrange
                        ) {
                            Task {
                                await viewModel.loadExercises(for: category)
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

// MARK: - Category Card

struct CategoryCard: View {
    let category: ExerciseCategory
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
            VStack(spacing: 16) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(category.color.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(category.color)
                }
                
                // Category name
                Text(category.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(category.color.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: category.color.opacity(isPressed ? 0.3 : 0.0),
                radius: isPressed ? 10 : 0,
                y: isPressed ? 5 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        CategorySelectionView(
            viewModel: AddExerciseViewModel(),
            accentGreen: Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255),
            brandOrange: Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
        )
    }
    .preferredColorScheme(.dark)
}
