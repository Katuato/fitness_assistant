//
//  User.swift
//  fitness_assistant
//
//  Created by katuato on 24.11.2025.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let passwordHash: String
    let name: String
    let birthDate: String
    let height: String
    let weight: String
    let gender: String
    let createdAt: Date
    let lastLogin: Date?
    let role: UserRole
    let locale: String?
    let level: String
    let goal: String
    
}

enum UserRole: String, Codable, CaseIterable {
    case user = "user"
    case admin = "admin"
    case trainer = "trainer"
    
    var displayName: String {
        switch self {
        case .user: return "User"
        case .admin: return "Administrator"
        case .trainer: return "Trainer"
        }
    }
}
