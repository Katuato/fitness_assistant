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
            VStack{
                VStack {
                    Text(pages[currentPage].title)
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .lineSpacing(0)
                        .padding(.bottom,80)
                    
                    if pages[currentPage].pageImage != "" {
                        Image(pages[currentPage].pageImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 280)
                    }
                }
                .padding(.top, topPaddingForCurrentPage)
                
                Spacer()
                
                if !isFirstPage {
                    HStack(spacing: 12) {
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
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                if isLastPage {
                    Button("START") {
                        completeOnboarding()
                    }
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 339, height: 81)
                            .background(Color.white.opacity(0))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    .padding(.horizontal, 45)
                    .padding(.bottom,70)
                    
                } else {
                    Button("NEXT") {
                        goToNextPage()
                    }
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 339, height: 81)
                    .background(Color.white.opacity(0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(.horizontal, 45)
                    .padding(.bottom, !isFirstPage ? 10 : 70)

                }
                
                if !isLastPage && !isFirstPage {
                    Button("Skip") {
                        skipOnboarding()
                    }
                    .font(.system(size: 24, weight: .bold))
                    .background(Color.white.opacity(0))
                    .foregroundColor(Color.white)
                    .padding(.bottom,  37)
                }
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
           }
       }
    private var topPaddingForCurrentPage: CGFloat {
        if currentPage == 0 {
            return 404
        } else if currentPage == pages.count - 1 {
            return 446
        } else {
            return 147
        }
    }
    

     private func goToNextPage() {
         guard currentPage < pages.count - 1 else { return }

             currentPage += 1

     }
     
    private func skipOnboarding() {
        onboardingService.completeOnboarding()
    }
     
     private func completeOnboarding() {
         onboardingService.completeOnboarding()
     }
}

