//
//  DashboardHeaderView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct DashboardHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Track your progress")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
            
            Text("Statistics")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DashboardHeaderView()
        .padding()
        .background(Color.customBackground)
        .preferredColorScheme(.dark)
}
