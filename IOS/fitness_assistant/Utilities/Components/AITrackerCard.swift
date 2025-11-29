//
//  AITrackerCard.swift
//  fitness_assistant
//
//  Changed by andrewfalse on 29.11.2025.
//

import SwiftUI

struct AITrackerCard: View {
    
    private var brandPurple: Color {
        Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255) // #7371DF
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255) // #E47E18
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.03))
            
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        brandPurple.opacity(0.9),
                        brandPurple.opacity(0.0)
                    ]),
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 220
                )
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        brandOrange.opacity(0.9),
                        brandOrange.opacity(0.0)
                    ]),
                    center: .bottomTrailing,
                    startRadius: 0,
                    endRadius: 220
                )
            }
            .blur(radius: 28)
            .mask(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
            
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.08),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .blendMode(.screen)
                .opacity(0.8)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.16))
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI TRACKER")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(brandOrange)
                        .textCase(.uppercase)
                    
                    Text("Start AI Tracking")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("AI will analyse your posture in real-time")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .frame(maxWidth: .infinity, minHeight: 110)
    }
}

#Preview {
    ZStack {
        Color.customBackground.ignoresSafeArea()
        AITrackerCard()
            .padding()
    }
    .preferredColorScheme(.dark)
}
