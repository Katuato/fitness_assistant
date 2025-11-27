//
//  HomeHeaderView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Ready to Train?")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeHeaderView()
        .padding()
        .background(Color.customBackground)
        .preferredColorScheme(.dark)
}
