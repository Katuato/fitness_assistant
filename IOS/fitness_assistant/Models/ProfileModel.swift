//
//  ProfileModel.swift
//  fitness_assistant
//
//  Created by andrewfalse on 28.11.2025.
//

import Foundation

// MARK: - Friend Model
struct Friend: Identifiable, Codable {
    let id: UUID
    let name: String
    let avatarInitials: String
    let isOnline: Bool
    let username: String
    let isRequestPending: Bool
    let mutualFriends: Int
    let streak: Int
    let accuracy: Int
    let isVerified: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        avatarInitials: String,
        isOnline: Bool = false,
        username: String,
        isRequestPending: Bool = false,
        mutualFriends: Int,
        streak: Int,
        accuracy: Int,
        isVerified: Bool
    ) {
        self.id = id
        self.name = name
        self.avatarInitials = avatarInitials
        self.isOnline = isOnline
        self.username = username
        self.isRequestPending = isRequestPending
        self.mutualFriends = mutualFriends
        self.streak = streak
        self.accuracy = accuracy
        self.isVerified = isVerified
    }
}


// MARK: - Equipment Model
struct Equipment: Identifiable, Codable {
    let id: UUID
    let name: String
    let iconName: String
    let category: String
    
    init(id: UUID = UUID(), name: String, iconName: String, category: String) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.category = category
    }
}

// MARK: - Achievement Model
struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    let earnedDate: Date?
    let isNew: Bool
    let progress: Double // 0.0 to 1.0
    
    var isUnlocked: Bool {
        earnedDate != nil
    }
    
    init(id: UUID = UUID(), title: String, description: String, iconName: String, earnedDate: Date? = nil, isNew: Bool = false, progress: Double = 0.0) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.earnedDate = earnedDate
        self.isNew = isNew
        self.progress = progress
    }
}

// MARK: - Profile Stats
struct ProfileStats {
    let friendsCount: Int
    let friendRequestsCount: Int
    let equipmentCount: Int
    let achievementsCount: Int
    let newAchievementsCount: Int
}

// MARK: - Mock Data
class ProfileMockData {
    static let friends: [Friend] = [
        Friend(
                    name: "Mike Johnson",
                    avatarInitials: "MJ",
                    isOnline: true,
                    username: "@mikeeeee",
                    isRequestPending: true,
                    mutualFriends: 3,
                    streak: 0,
                    accuracy: 0,
                    isVerified: false
                ),
                Friend(
                    name: "Sarah Davis",
                    avatarInitials: "SD",
                    isOnline: false,
                    username: "@sarahd",
                    isRequestPending: true,
                    mutualFriends: 2,
                    streak: 0,
                    accuracy: 0,
                    isVerified: true
                ),
                
                // Мои друзья
                Friend(
                    name: "Ekaterina Kalmykova",
                    avatarInitials: "EK",
                    isOnline: true,
                    username: "@katuato",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 45,
                    accuracy: 80,
                    isVerified: true
                ),
                Friend(
                    name: "Alex Johnson",
                    avatarInitials: "AJ",
                    isOnline: true,
                    username: "@alexj",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 30,
                    accuracy: 92,
                    isVerified: true
                ),
                Friend(
                    name: "Maria Garcia",
                    avatarInitials: "MG",
                    isOnline: false,
                    username: "@mariag",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 15,
                    accuracy: 75,
                    isVerified: false
                ),
                Friend(
                    name: "John Smith",
                    avatarInitials: "JS",
                    isOnline: true,
                    username: "@johns",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 7,
                    accuracy: 85,
                    isVerified: false
                ),
                Friend(
                    name: "Emma Wilson",
                    avatarInitials: "EW",
                    isOnline: false,
                    username: "@emmaw",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 22,
                    accuracy: 88,
                    isVerified: true
                ),
                Friend(
                    name: "Michael Brown",
                    avatarInitials: "MB",
                    isOnline: true,
                    username: "@mikeb",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 3,
                    accuracy: 70,
                    isVerified: false
                ),
                Friend(
                    name: "Chris Lee",
                    avatarInitials: "CL",
                    isOnline: true,
                    username: "@chrisl",
                    isRequestPending: false,
                    mutualFriends: 0,
                    streak: 60,
                    accuracy: 95,
                    isVerified: true
                ),
                Friend(
                    name: "Ashley Martinez",
                    avatarInitials: "AM",
                    isOnline: false,
                    username: "@ashleym",
                    isRequestPending: false,
                    mutualFriends: 1,
                    streak: 18,
                    accuracy: 78,
                    isVerified: false
                )
            
    ]
    
    static let equipment: [Equipment] = [
        Equipment(name: "Dumbbells", iconName: "dumbbell.fill", category: "Strength"),
        Equipment(name: "Yoga Mat", iconName: "figure.yoga", category: "Flexibility"),
        Equipment(name: "Resistance Bands", iconName: "bandage.fill", category: "Resistance")
    ]
    
    static let achievements: [Achievement] = [
        Achievement(
            title: "First Workout",
            description: "Complete your first workout session",
            iconName: "star.fill",
            earnedDate: Date().addingTimeInterval(-86400 * 30),
            isNew: false,
            progress: 1.0
        ),
        Achievement(
            title: "Week Warrior",
            description: "Train for 7 days straight",
            iconName: "flame.fill",
            earnedDate: Date().addingTimeInterval(-86400 * 7),
            isNew: false,
            progress: 1.0
        ),
        Achievement(
            title: "Perfect Form",
            description: "Achieve 95% accuracy in a workout",
            iconName: "checkmark.seal.fill",
            earnedDate: Date().addingTimeInterval(-86400 * 2),
            isNew: true,
            progress: 1.0
        ),
        Achievement(
            title: "Hundred Club",
            description: "Complete 100 workouts",
            iconName: "trophy.fill",
            earnedDate: nil,
            isNew: false,
            progress: 0.12
        )
    ]
    
    static func getStats() -> ProfileStats {
        ProfileStats(
            friendsCount: friends.count,
            friendRequestsCount: 1,
            equipmentCount: equipment.count,
            achievementsCount: achievements.count,
            newAchievementsCount: achievements.filter { $0.isNew }.count
        )
    }
}
