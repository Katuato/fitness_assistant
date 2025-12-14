//
//  SessionCard.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct SessionCard: View {
    let session: WorkoutSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(session.formattedDate)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                
                Spacer()
                
                Text(session.bodyPart)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(session.bodyPart == "Upper Body" ? Color.purple.opacity(0.8) : Color.blue.opacity(0.8))
                    )
            }
            
            HStack(alignment: .bottom, spacing: 24) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Exercises")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text("\(session.exerciseCount)")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total time")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text(session.formattedTime)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Accuracy")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text(session.formattedAccuracy)
                        .font(.title2.bold())
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
        )
    }
}
