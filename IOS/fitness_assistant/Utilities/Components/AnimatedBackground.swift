//
//  AnimatedBackground.swift
//  fitness_assistant
//
//  Created by andrewfalse on 12.12.2025.
//

import SwiftUI

struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            // Background image from Assets
            Image("page_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Optional dark overlay for better text readability
            Color.black.opacity(0.2)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    AnimatedBackground()
}
