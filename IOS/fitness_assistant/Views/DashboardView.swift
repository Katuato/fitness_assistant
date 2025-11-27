//
//  DashboardView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.customBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    DashboardHeaderView()
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    if let stats = viewModel.weeklyStats {
                        WeeklyStatsCard(stats: stats)
                            .padding(.horizontal, 20)
                    }
                    
                    if !viewModel.recentSessions.isEmpty {
                        RecentSessionsSection(
                            sessions: viewModel.recentSessions,
                            onViewAll: {
                                print("View all sessions tapped")
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}

