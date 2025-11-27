//
//  AnalysisView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        ZStack {
            // Основной фон
            Color.customBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Analysis")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Video AI Analysis")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                
                Spacer()
                
                // placeholder для будущего функционала
                Image(systemName: "video.badge.checkmark")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("Coming Soon")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AnalysisView()
}
