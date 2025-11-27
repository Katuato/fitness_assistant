//
//  RecentSessionsSection.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct RecentSessionsSection: View {
    let sessions: [WorkoutSession]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Sessions")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button(action: onViewAll) {
                    Text("View all")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                }
            }
            
            ForEach(sessions) { session in
                SessionCard(session: session)
            }
        }
    }
}

#Preview {
    let mockSessions = [
        WorkoutSession(
            date: Date(),
            exerciseCount: 2,
            totalTime: 45,
            accuracy: 82,
            bodyPart: "Upper Body"
        ),
        WorkoutSession(
            date: Date().addingTimeInterval(-86400),
            exerciseCount: 4,
            totalTime: 85,
            accuracy: 61,
            bodyPart: "Full Body"
        )
    ]
    
    return RecentSessionsSection(sessions: mockSessions, onViewAll: {})
        .padding()
        .background(Color.customBackground)
        .preferredColorScheme(.dark)
}
