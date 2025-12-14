//
//  AuthModels.swift
//  fitness_assistant
//
//  Models for authentication requests and responses
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
    let birthDate: String?
    let gender: String?
    let height: String?
    let weight: String?
    let locale: String?
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
}
