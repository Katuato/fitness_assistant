//
//  OnboardingView.swift
//  fitness_assistant
//
//  Created by katuato on 25.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject var onboardingService: OnboardingService
    @State private var isAnimating = false
    
    private let pages = OnboardingData.pages
    private var isFirstPage: Bool { currentPage == 0 }
    private var isLastPage: Bool { currentPage == pages.count - 1 }
    
    var body: some View {
        ZStack {
            
            Image(pages[currentPage].backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 40) {
                    Text(pages[currentPage].title)
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .lineSpacing(6)
    

                Image(pages[currentPage].pageImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Group {
                            if index == currentPage {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color.white)
                                    .frame(width: 28, height: 13)
                            } else {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 13, height: 13)
                            }
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                currentPage = index
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }

    }
}

