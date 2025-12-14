//
//  ProfileViewModel.swift
//  fitness_assistant
//
//  Created by andrewfalse on 28.11.2025.
//

import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var friends: [Friend] = []
    @Published var equipment: [Equipment] = []
    @Published var achievements: [Achievement] = []
    @Published var stats: ProfileStats?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Gradient animation
    @Published var gradientRotation: Double = 0.0
    
    private var gradientTimer: Timer?
    private var authService: AuthService?
    
    init() {
        loadMockData()
        startGradientAnimation()
    }
    
    // MARK: - Setup with AuthService
    
    func setup(with authService: AuthService) {
        self.authService = authService
        loadUserData(from: authService)
    }
    
    private func loadUserData(from authService: AuthService) {
        // Используем реальные данные из AuthService
        self.user = authService.currentUser
        
        // Если данных нет, загружаем mock
        if user == nil {
            loadMockData()
        }
    }
    
//    nonisolated deinit {
//        // Останавливаем таймер без обращения к @MainActor методам
//        Task { @MainActor [weak gradientTimer] in
//            gradientTimer?.invalidate()
//        }
//    }
    
    // MARK: - Data Loading
    func loadMockData() {
        isLoading = true
        
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Загружаем только вспомогательные данные (не user!)
            self.friends = ProfileMockData.friends
            self.equipment = ProfileMockData.equipment
            self.achievements = ProfileMockData.achievements
            self.stats = ProfileMockData.getStats()
            self.isLoading = false
        }
    }
    
    // MARK: - Computed Properties
    
    var userInitials: String {
        user?.initials ?? "UN"
    }
    
    var userName: String {
        user?.displayName ?? "Username"
    }
    
    // MARK: - Gradient Animation
    private func startGradientAnimation() {
        // Используем более плавную анимацию с меньшим интервалом
        gradientTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                withAnimation(.linear(duration: 0.016)) {
                    self.gradientRotation += 0.5
                    if self.gradientRotation >= 360 {
                        self.gradientRotation = 0
                    }
                }
            }
        }
        // Добавляем таймер в RunLoop для обеспечения плавности
        if let timer = gradientTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func stopGradientAnimation() {
        gradientTimer?.invalidate()
        gradientTimer = nil
    }
    
    // MARK: - Actions
    func signOut() {
        // Clear user data
        user = nil
        friends.removeAll()
        equipment.removeAll()
        achievements.removeAll()
        stats = nil
        
        // Reset onboarding to show it again
        if let onboardingService = getOnboardingService() {
            onboardingService.resetOnboarding()
        }
    }
    
    private func getOnboardingService() -> OnboardingService? {
        // This will be injected from the view
        return nil
    }
    
    func openFriends() {
        print("Opening friends list")
    }
    
    func openEquipment() {
        print("Opening equipment list")
    }
    
    func openAchievements() {
        print("Opening achievements list")
    }
}
