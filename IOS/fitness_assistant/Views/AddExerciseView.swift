//
//  AddExerciseView.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 04.12.2025.
//

import SwiftUI

struct AddExerciseView: View {
    let onDismiss: () -> Void
    let onExerciseAdded: (Exercise) -> Void
    
    @StateObject private var viewModel = AddExerciseViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var isPresented = false
    
    private let dismissThreshold: CGFloat = 200
    
    // MARK: - Brand Colors
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    // MARK: - Computed Properties
    
    private var dimmingOpacity: Double {
        let progress = max(0, min(1, 1 - (dragOffset / UIScreen.main.bounds.height)))
        return progress * 0.4
    }
    
    private var sheetOffset: CGFloat {
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
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                isPresented = true
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
            
            // Header with title and close button
            headerSection()
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            // Content based on navigation state
            Group {
                if viewModel.navigationState == .categorySelection {
                    CategorySelectionView(
                        viewModel: viewModel,
                        accentGreen: accentGreen,
                        brandOrange: brandOrange
                    )
                    .id("category")
                } else if viewModel.navigationState == .exerciseGrid {
                    ExerciseGridView(
                        viewModel: viewModel,
                        accentGreen: accentGreen,
                        brandOrange: brandOrange
                    )
                    .id("grid")
                } else if viewModel.navigationState == .exerciseDetail {
                    ExerciseDetailView(
                        viewModel: viewModel,
                        accentGreen: accentGreen,
                        brandOrange: brandOrange,
                        onAddExercise: { exercise in
                            handleAddExercise(exercise)
                        }
                    )
                    .id("detail")
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: viewModel.navigationDirection == .forward ? .trailing : .leading),
                removal: .move(edge: viewModel.navigationDirection == .forward ? .leading : .trailing)
            ))
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.navigationState)
        }
        .frame(maxWidth: .infinity)
        .frame(height: geometry.size.height * 0.95)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.customBackground)
                .shadow(color: .black.opacity(0.3), radius: 30, y: -10)
                .ignoresSafeArea(edges: .bottom)
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
            Text("Add Exercise")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
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
    
    // MARK: - Actions
    
    private func dismissWithAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isPresented = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            viewModel.reset()
            onDismiss()
        }
    }
    
    private func handleAddExercise(_ categorizedExercise: CategorizedExercise) {
        viewModel.trackExerciseAdded(exerciseId: categorizedExercise.id)
        
        let exercise = categorizedExercise.toExercise()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isPresented = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onExerciseAdded(exercise)
            viewModel.reset()
            onDismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        AddExerciseView(
            onDismiss: {},
            onExerciseAdded: { _ in }
        )
    }
    .preferredColorScheme(.dark)
}
