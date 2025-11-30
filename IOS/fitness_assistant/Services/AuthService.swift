//
//  AuthService.swift
//  fitness_assistant
//
//  Created by katuato on 29.11.2025.
//

import Foundation

class AuthService: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    func login(email: String, password: String) {
        // Добавить логику автори зации
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
    }
}
