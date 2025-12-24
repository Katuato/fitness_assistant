//
//  AuthService.swift
//  fitness_assistant
//
//  Created by katuato on 29.11.2025.
//

import Foundation

@MainActor
class AuthService: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let networkService = NetworkService.shared
    private let keychainService = KeychainService.shared
    private var hasCheckedAuth = false
    
    init() {
        // Check if user has valid tokens on init
        checkAuthStatus()
    }
    
    // MARK: - Registration
    
    func register(
        email: String,
        password: String,
        name: String,
        birthDate: String? = nil,
        gender: String? = nil,
        height: String? = nil,
        weight: String? = nil,
        locale: String? = nil
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = RegisterRequest(
                email: email,
                password: password,
                name: name,
                birthDate: birthDate,
                gender: gender,
                height: height,
                weight: weight,
                locale: locale
            )
            let response: TokenResponse = try await networkService.request(
                endpoint: "/auth/register",
                method: .post,
                body: request
            )
            
            // Save tokens
            _ = keychainService.saveTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            
            // Fetch user data
            await fetchCurrentUser()
            
            isAuthenticated = true
            isLoading = false
            
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
            isLoading = false
        } catch {
            errorMessage = "An unexpected error occurred"
            isLoading = false
        }
    }
    
    // MARK: - Login
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = LoginRequest(email: email, password: password)
            let response: TokenResponse = try await networkService.request(
                endpoint: "/auth/login",
                method: .post,
                body: request
            )
            
            // Save tokens
            _ = keychainService.saveTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            
            // Fetch user data
            await fetchCurrentUser()
            
            isAuthenticated = true
            isLoading = false
            
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
            isLoading = false
        } catch {
            errorMessage = "An unexpected error occurred"
            isLoading = false
        }
    }
    
    // MARK: - Logout
    
    func logout() async {
        // Call backend logout (optional, as tokens are stored client-side)
        do {
            let _: MessageResponse = try await networkService.request(
                endpoint: "/auth/logout",
                method: .post,
                requiresAuth: true
            )
        } catch {
            // Ignore logout errors, proceed with local cleanup
            print("Logout error: \(error)")
        }
        
        // Clear local data
        _ = keychainService.deleteAllTokens()
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - Refresh Token
    
    func refreshTokens() async -> Bool {
        guard let refreshToken = keychainService.getRefreshToken() else {
            return false
        }
        
        do {
            let request = RefreshTokenRequest(refreshToken: refreshToken)
            let response: TokenResponse = try await networkService.request(
                endpoint: "/auth/refresh",
                method: .post,
                body: request
            )
            
            // Save new tokens
            _ = keychainService.saveTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            
            return true
            
        } catch {
            // Refresh failed, user needs to login again
            _ = keychainService.deleteAllTokens()
            isAuthenticated = false
            return false
        }
    }
    
    // MARK: - Fetch Current User
    
    func fetchCurrentUser() async {
        do {
            let user: User = try await networkService.request(
                endpoint: "/auth/me",
                method: .get,
                requiresAuth: true
            )

            currentUser = user
            isAuthenticated = true

        } catch let error as NetworkError {
            if case .unauthorized = error {
                // Try to refresh token
                let refreshed = await refreshTokens()
                if refreshed {
                    // Retry fetching user
                    await fetchCurrentUser()
                } else {
                    isAuthenticated = false
                }
            } else {
                // For decoding errors, don't show them as user-facing errors
                // since authentication still works and tokens are saved
                if case .decodingError = error {
                    print("⚠️ User profile fetch failed due to decoding error, but authentication succeeded")
                    // Set a basic user state if we have tokens but can't fetch profile
                    isAuthenticated = true
                    currentUser = nil
                } else {
                    errorMessage = error.errorDescription
                }
            }
        } catch {
            errorMessage = "Failed to fetch user data"
        }
    }
    
    // MARK: - Check Auth Status
    
    private func checkAuthStatus() {
        // Only check once at app launch
        guard !hasCheckedAuth else { return }
        hasCheckedAuth = true
        
        // Check if we have tokens
        if keychainService.getAccessToken() != nil {
            Task {
                await fetchCurrentUser()
            }
        }
    }
}
