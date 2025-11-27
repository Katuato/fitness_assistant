//
//  AITrackerCard.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct AITrackerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AI TRACKER")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.orange)
            
            Text("Start AI Tracking")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("AI will analyse your posture in real-time")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.orange.opacity(0.2),
                            Color.blue.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

#Preview {
    AITrackerCard()
        .padding()
        .background(Color.customBackground)
        .preferredColorScheme(.dark)
}
