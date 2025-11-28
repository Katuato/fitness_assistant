//
//  ProfileView.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var onboardingService: OnboardingService
    
    @State private var showFriends = false
    @State private var showEquipment = false
    @State private var showAchievements = false
    
    // MARK: - Colors for design
    
    private var gradientPurple: Color {
        Color(red: 0x73 / 255, green: 0x71 / 255, blue: 0xDF / 255)
    }
    
    private var gradientOrange: Color {
        Color(red: 0xE4 / 255, green: 0x7E / 255, blue: 0x18 / 255)
    }
    
    private var friendsColor: Color {
        gradientPurple
    }
    
    private var equipmentColor: Color {
        gradientOrange
    }
    
    private var achievementsColor: Color {
        Color(red: 0x39 / 255, green: 0xD9 / 255, blue: 0x63 / 255) // ярко-зеленый
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.customBackground
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header Card
                        ProfileHeaderCard(
                            userName: viewModel.userName,
                            userInitials: viewModel.userInitials,
                            gradientRotation: viewModel.gradientRotation
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        // Section title
                        HStack {
                            Text("My info")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        // Menu Items
                        VStack(spacing: 14) {
                            ProfileMenuItem(
                                icon: "person.2.fill",
                                accentColor: friendsColor,
                                title: "Friends",
                                subtitle: "\(viewModel.stats?.friendsCount ?? 0) users",
                                rightValue: viewModel.stats?.friendRequestsCount ?? 0 > 0
                                    ? "+\(viewModel.stats?.friendRequestsCount ?? 0)"
                                    : nil,
                                rightCaption: "request",
                                action: { showFriends = true }
                            )
                            
                            ProfileMenuItem(
                                icon: "dumbbell.fill",
                                accentColor: equipmentColor,
                                title: "Equipment",
                                subtitle: "\(viewModel.stats?.equipmentCount ?? 0) pieces",
                                rightValue: nil,
                                rightCaption: nil,
                                action: { showEquipment = true }
                            )
                            
                            ProfileMenuItem(
                                icon: "trophy.fill",
                                accentColor: achievementsColor,
                                title: "Achievements",
                                subtitle: "\(viewModel.stats?.achievementsCount ?? 0) achievements",
                                rightValue: viewModel.stats?.newAchievementsCount ?? 0 > 0
                                    ? "+\(viewModel.stats?.newAchievementsCount ?? 0)"
                                    : nil,
                                rightCaption: "new",
                                action: { showAchievements = true }
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // Sign Out Button (outline style, как на макете)
                        Button(action: {
                            viewModel.signOut()
                            onboardingService.resetOnboarding()
                        }) {
                            Text("Sign out")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(gradientOrange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(gradientOrange, lineWidth: 1.5)
                                )
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $showFriends) {
                FriendsListView(friends: viewModel.friends)
            }
            .navigationDestination(isPresented: $showEquipment) {
                EquipmentListView(equipment: viewModel.equipment)
            }
            .navigationDestination(isPresented: $showAchievements) {
                AchievementsListView(achievements: viewModel.achievements)
            }
        }
    }
}

// MARK: - Profile Header Card

struct ProfileHeaderCard: View {
    let userName: String
    let userInitials: String
    let gradientRotation: Double
    
    private var brandPurple: Color {
        Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255) // #7371DF
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255) // #E47E18
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBackground)
            
            // First animated gradient layer — updated colors
            AngularGradient(
                gradient: Gradient(colors: [
                    brandOrange.opacity(0.85),
                    brandPurple.opacity(0.85),
                    brandOrange.opacity(0.85),
                    brandPurple.opacity(0.85),
                    brandOrange.opacity(0.85)
                ]),
                center: .center,
                angle: .degrees(gradientRotation)
            )
            .blur(radius: 40)
            .opacity(0.55)
            
            // Second depth layer — updated colors
            RadialGradient(
                gradient: Gradient(colors: [
                    brandOrange.opacity(0.35),
                    brandPurple.opacity(0.28),
                    Color.clear
                ]),
                center: .center,
                startRadius: 20,
                endRadius: 150
            )
            .blur(radius: 22)
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.10),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 16) {
                // Avatar Circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 64, height: 64)
                    
                    Text(userInitials)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Fitness Enthusiast")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(20)
        }
        .frame(height: 104)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: brandOrange.opacity(0.30), radius: 20, x: 0, y: 10)
        .shadow(color: brandPurple.opacity(0.22), radius: 15, x: 0, y: 5)
    }
}

// MARK: - Profile Menu Item

struct ProfileMenuItem: View {
    let icon: String
    let accentColor: Color
    let title: String
    let subtitle: String
    let rightValue: String?
    let rightCaption: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Иконка слева, без «плашки», как на макете
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(accentColor)
                    .frame(width: 28, alignment: .center)
                
                // Текст слева
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Правая колонка (+1 request / +1 new)
                if let rightValue, let rightCaption {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(rightValue)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(accentColor)
                        
                        Text(rightCaption)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.35))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Friends List View (Placeholder)

struct FriendsListView: View {
    let friends: [Friend]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(friends) { friend in
                        HStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                
                                Text(friend.avatarInitials)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            // Name
                            VStack(alignment: .leading, spacing: 4) {
                                Text(friend.name)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(friend.isOnline ? Color.green : Color.gray)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(friend.isOnline ? "Online" : "Offline")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Equipment List View (Placeholder)

struct EquipmentListView: View {
    let equipment: [Equipment]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(equipment) { item in
                        HStack(spacing: 16) {
                            // Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: item.iconName)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.orange)
                            }
                            
                            // Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(item.category)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Equipment")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Achievements List View (Placeholder)

struct AchievementsListView: View {
    let achievements: [Achievement]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(achievements) { achievement in
                        HStack(spacing: 16) {
                            // Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(achievement.isUnlocked ? Color.orange.opacity(0.2) : Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: achievement.iconName)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(achievement.isUnlocked ? .orange : .gray)
                            }
                            
                            // Info
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(achievement.title)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if achievement.isNew {
                                        Text("NEW")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.orange)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                Text(achievement.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                    .lineLimit(2)
                                
                                if !achievement.isUnlocked {
                                    ProgressView(value: achievement.progress)
                                        .tint(.orange)
                                        .padding(.top, 4)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    ProfileView()
        .environmentObject(OnboardingService())
        .preferredColorScheme(.dark)
}
