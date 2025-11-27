//
//  StatCard.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.orange)
            
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard(value: "12", label: "Workouts")
        StatCard(value: "42", label: "Day Streak")
        StatCard(value: "91%", label: "Accuracy")
    }
    .padding()
    .background(Color.customBackground)
    .preferredColorScheme(.dark)
}
