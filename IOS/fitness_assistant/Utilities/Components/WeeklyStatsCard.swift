//
//  WeeklyStatsCard.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct WeeklyStatsCard: View {
    let stats: WeeklyStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(stats.weekLabel)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(stats.formattedAccuracy)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.green)
                
                Text("Avg Accuracy")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
        )
    }
}
