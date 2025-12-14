//
//  AddExerciseButton.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct AddExerciseButton: View {
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var pulseAnimation = false
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    private var accentGreen: Color {
        Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    }
    
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
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentGreen.opacity(0.3),
                                    accentGreen.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .opacity(pulseAnimation ? 0.7 : 1.0)
                    
                    Circle()
                        .fill(accentGreen.opacity(0.2))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(accentGreen)
                }
                
                Text("Add Exercise")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                .white,
                                .white.opacity(0.9)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(accentGreen)
                    .offset(x: isPressed ? 4 : 0)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(
                                Color.white.opacity(isPressed ? 0.2 : 0.12),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: Color.black.opacity(isPressed ? 0.2 : 0.1),
                radius: isPressed ? 10 : 5,
                x: 0,
                y: isPressed ? 5 : 2
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                pulseAnimation = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        
        VStack(spacing: 20) {
            AddExerciseButton()
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
