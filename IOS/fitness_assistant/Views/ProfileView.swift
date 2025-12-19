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
    @State private var showSettings = false


    
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
        Color(red: 0x39 / 255, green: 0xD9 / 255, blue: 0x63 / 255)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.customBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    ProfileHeaderCard(
                        userName: viewModel.userName,
                        userInitials: viewModel.userInitials,
                        gradientRotation: viewModel.gradientRotation,
                        showSettings: $showSettings
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 116)
                    
                    HStack {
                        Text("My info")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: 19) {
                        ProfileMenuItem(
                            icon: "friends",
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
                            icon: "equipment",
                            accentColor: equipmentColor,
                            title: "Equipment",
                            subtitle: "\(viewModel.stats?.equipmentCount ?? 0) pieces",
                            rightValue: nil,
                            rightCaption: nil,
                            action: { showEquipment = true }
                        )
                        
                        ProfileMenuItem(
                            icon: "achievements",
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
                    .padding(.top, 50)
                    
                    Spacer(minLength: 80)
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
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct ProfileHeaderCard: View {
    let userName: String
    let userInitials: String
    let gradientRotation: Double
    @Binding var showSettings: Bool
    
    private var brandPurple: Color {
        Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255)
    }
    
    private var brandOrange: Color {
        Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
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
                        .frame(width: 95, height: 95)
                        .overlay(
                            Image("UN")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 95, height: 95)
                                .foregroundColor(.white)
                        )
                    
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 95, height: 95)
                    
                    Text(userInitials)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(userName)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSettings = true
                    }) {
                        Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding(12)
                    }
                    .padding(.top, 13)
                    .padding(.trailing, 13)
                }
                Spacer()
            }
        }
        .frame(height: 196)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGrey, lineWidth: 1)
        )
        .background(
            Image("user_profile_block_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 369, height: 196)
                .cornerRadius(20)
        )
        .shadow(color: brandOrange.opacity(0.30), radius: 20, x: 0, y: 10)
        .shadow(color: brandPurple.opacity(0.22), radius: 15, x: 0, y: 5)
    }
}

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
            HStack(spacing: 18) {
                ZStack {
                    Image(icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(accentColor)
                }
                .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.vertical, 8)
                
                Spacer()

                if let rightValue, let rightCaption {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(rightValue)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(accentColor)
                        
                        Text(rightCaption)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.35))
                    .padding(.leading, 4)
            }
            .frame(height: 80)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.lightGrey, lineWidth: 0.5)

            )
        }
    }
}

struct FriendsListView: View {
    let friends: [Friend]
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""

    private var friendRequests: [Friend] {
        friends.filter { $0.isRequestPending }
    }
    
    private var myFriends: [Friend] {
        friends.filter { !$0.isRequestPending }
    }
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            Image("create_account_view_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 5) {
                VStack {
                    Text("Friends")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(myFriends.count) connections")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 16)
                .padding(.top, 101)
                .padding(.bottom, 20)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0))
                        .padding(.leading, 16)
                        
                    
                    TextField("Search friends...", text: $searchText)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.leading, 8)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.trailing, 16)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.lightGrey, lineWidth: 0.5)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                

                Button(action: {
                    // Действие добавления друга
                }) {
                    HStack {
                        Spacer()
                        Image( "add_friend")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Add Friend")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .multilineTextAlignment(.center)
                    .background(
                            // Градиентный фон как на скриншоте
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    Gradient.Stop(color: Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255), location: 0.0),
                                    Gradient.Stop(color: Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255), location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .opacity(1.0)
                            .cornerRadius(20
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            Gradient.Stop(color: Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255), location: 0.0),
                                            Gradient.Stop(color: Color(red: 0x73/255, green: 0x71/255, blue: 0xDF/255), location: 1.0)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1
                                )
                        ))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Запросы в друзья
                        if !friendRequests.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Friends Requests")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                
                                ForEach(friendRequests) { friend in
                                    FriendRequestCard(friend: friend)
                                }
                            }
                        }
                        
                        // Мои друзья
                        VStack(alignment: .leading, spacing: 12) {
                            Text("My Friends")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                            
                            ForEach(myFriends) { friend in
                                FriendCard(friend: friend)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// Карточка друга (для "My Friends")
struct FriendCard: View {
    let friend: Friend
    
    var body: some View {
        let streak = friend.streak
        let accuracy = friend.accuracy
        HStack(spacing: 16) {
            // Аватар с инициалами
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                
                Text(friend.avatarInitials)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(friend.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if friend.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "at")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(friend.username)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.6))
                }
                

                    HStack(spacing: 8) {
                        Text("\(streak) day streak")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.orange)
                        
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 4, height: 4)
                        
                        Text("\(accuracy)% accuracy")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                    }
                
            }
            
            Spacer()
            
            // Кнопка действий
            Menu {
                Button(action: {
                    // Удалить из друзей
                }) {
                    Label("Remove Friend", systemImage: "person.slash")
                }
                
                Button(action: {
                    // Заблокировать
                }) {
                    Label("Block", systemImage: "nosign")
                }
                
                Button(action: {
                    // Отправить сообщение
                }) {
                    Label("Message", systemImage: "message")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 44, height: 44)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.lightGrey, lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 16)
    }
}

// Карточка запроса в друзья
struct FriendRequestCard: View {
    let friend: Friend
    var body: some View {
        let mutualFriends = friend.mutualFriends
        HStack(spacing: 16) {
            // Аватар
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                
                Text(friend.avatarInitials)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(friend.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "at")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(friend.username)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                if  mutualFriends > 0 {
                    Text("\(mutualFriends) mutual friends")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Кнопки принятия/отклонения
            HStack(spacing: 8) {
                Button(action: {
                    // Принять запрос
                }) {
                    Text("Accept")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green, lineWidth: 1)
                                )
                        )
                }
                
                Button(action: {
                    // Отклонить запрос
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.lightGrey, lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 16)
    }
}

struct EquipmentListView: View {
    let equipment: [Equipment]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            Image("create_account_view_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ForEach(equipment) { item in
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: item.iconName)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.orange)
                        }
                        
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
                
                Spacer()
            }
            .padding(16)
        }
        .navigationTitle("Equipment")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct AchievementsListView: View {
    let achievements: [Achievement]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            Image("create_account_view_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(achievement.isUnlocked ? Color.orange.opacity(0.2) : Color.gray.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: achievement.iconName)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(achievement.isUnlocked ? .orange : .gray)
                        }
                        
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
                
                Spacer()
            }
            .padding(16)
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

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showChangeUserInfo = false
    @StateObject private var viewModel = ProfileViewModel()
//    @EnvironmentObject var userService: UserService
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.customBackground.ignoresSafeArea()
                VStack{
                    HStack {
                        Text("ACCOUNT")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.lightGrey)
                        Spacer()
                    }
//                    .padding(.horizontal, 16)
                    .padding(.top, 22)
                    
                    Button(action: {
                        showChangeUserInfo = true
                    }){
                        HStack(spacing: 18) {
                            ZStack {
                                Image("edit_profile_icon")
                                    .font(.system(size: 22, weight: .semibold))
                            }
                            .frame(width: 48, height: 48)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Edit Profile")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Name, photo, parameters")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.vertical, 8)
                            
                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.35))
                                .padding(.leading, 4)
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.lightGrey, lineWidth: 0.5)

                        )
                    }
                    .padding(.bottom, 12)
                    
                    Button(action: {
                        // Переход на старницу с правами
                    }){
                        HStack(spacing: 18) {
                            ZStack {
                                Image("privacy_icon")
                                    .font(.system(size: 22, weight: .semibold))
                            }
                            .frame(width: 48, height: 48)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Privacy & Security")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Password, data")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.vertical, 8)
                            
                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.35))
                                .padding(.leading, 4)
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.lightGrey, lineWidth: 0.5)

                        )
                    }
                    .padding(.bottom, 24)
                    
                    HStack {
                        Text("ABOUT")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.lightGrey)
                        Spacer()
                    }
//                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    Button(action: {
                        // Переход на старницу с правами
                    }){
                        HStack(spacing: 18) {
                            VStack(alignment: .leading) {
                                Text("Help & Support")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            
                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.35))
                                .padding(.leading, 4)
                        }
                        .frame(height: 26)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.lightGrey, lineWidth: 0.5)

                        )
                    }
                    .padding(.bottom, 8)
                    
                    Button(action: {
                        // Переход на старницу с правами
                    }){
                        HStack(spacing: 18) {
                            VStack(alignment: .leading) {
                                Text("Terms & Privacy")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            
                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.35))
                                .padding(.leading, 4)
                        }
                        .frame(height: 26)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.lightGrey, lineWidth: 0.5)

                        )
                    }
                    .padding(.bottom, 8)
                    
                        HStack(spacing: 18) {
                            VStack(alignment: .leading) {
                                Text("Version 1.0.0")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            
                            Spacer()

                        }
                        .frame(height: 26)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.lightGrey, lineWidth: 0.5)

                        )
                    Spacer()

                }
                .padding(.horizontal, 16)

            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .navigationDestination(isPresented: $showChangeUserInfo ) {

                ChangeUserInfoView(user: User(
                    id: 1,
                    email: "user@example.com",
                    passwordHash: "",
                    name: "katuato",
                    birthDate: "1990-01-01",
                    height: "180",
                    weight: "75",
                    gender: "male",
                    createdAt: Date(),
                    lastLogin: Date(),
                    role: .user,
                    locale: "en",
                    level: "beginner",
                    goal: "weight loss"
                ))

        }
        
    }
    
}


struct ChangeUserInfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var birthDate = Date()
    @State private var selectedGender: String = ""
    @State private var selectedHeight: String = ""
    @State private var selectedWeight: String = ""
    @State private var selectedLevel: String = ""
    @State private var selectedGoal: String = ""
    @State private var originalUser: User
    
    init(user: User) {
        _originalUser = State(initialValue: user)

    }
    
    let genders = ["male", "female", "other"]
    let heights = Array(140...220).map { "\($0) cm" }
    let weights = Array(40...150).map { "\($0) kg" }
    let trainingLevels = ["beginner", "intermediate", "advanced", "professional"]
    let goals = ["weight loss", "muscle gain", "maintenance", "endurance", "general fitness"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("create_account_view_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                ScrollView {
                VStack{
                    
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
                            .frame(width: 130, height: 130)
                            .overlay(
                                Image("UN")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.white)
                            )
                        
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 130, height: 130)
                        
                        Text("ИН")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 62)
                    
                        VStack(spacing: 15) {
                            Group {
                                CustomTextField(
                                    text: $userName,
                                    placeholder: originalUser.name,
                                    iconName: "person"
                                )
                                
                                CustomTextField(
                                    text: $email,
                                    placeholder: originalUser.email,
                                    iconName: "envelope"
                                )
                                
                                CustomTextField(
                                    text: $password,
                                    placeholder: "password",
                                    iconName: "lock",
                                    isSecure: true
                                )
                                
                                CustomTextField(
                                    text: $confirmPassword,
                                    placeholder: "confirm password",
                                    iconName: "lock",
                                    isSecure: true
                                )
                            }
                                
                            CustomDatePicker(selection: $birthDate,
                                             placeholder: formatBirthDate(originalUser.birthDate),
                                            iconName: "calendar")
                            

                            Group {
                                CustomDropdownMenu(
                                    selectedValue: $selectedGender,
                                    placeholder: originalUser.gender,
                                    options: genders,
                                    iconName: "person.2"
                                )
                                
                                CustomDropdownMenu(
                                    selectedValue: $selectedHeight,
                                    placeholder: originalUser.height,
                                    options: heights,
                                    iconName: "ruler"
                                )
                                
                                CustomDropdownMenu(
                                    selectedValue: $selectedWeight,
                                    placeholder: originalUser.weight,
                                    options: weights,
                                    iconName: "scalemass"
                                )
                                
                                CustomDropdownMenu(
                                    selectedValue: $selectedLevel,
                                    placeholder: originalUser.level,
                                    options: trainingLevels,
                                    iconName: "chart.bar"
                                )
                                
                                CustomDropdownMenu(
                                    selectedValue: $selectedGoal,
                                    placeholder: originalUser.goal,
                                    options: goals,
                                    iconName: "target"
                                )
                            }

                            Button("SAVE CHANGES") {
                                //Переход на главную страницу
                            }
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 339, height: 81)
                            .background(Color.white.opacity(0))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding(.top, 30)
                            .padding(.bottom,45)
                            
                            Spacer()
                    
                    
                    
                }
                


                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
}

private func formatBirthDate(_ dateString: String?) -> String {
    guard let dateString = dateString, !dateString.isEmpty else {
        return "birthdate"
    }
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd.MM.yyyy"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return dateString
    }
}
