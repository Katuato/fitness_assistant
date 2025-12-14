//
//  KeychainService.swift
//  fitness_assistant
//
//  Service for securely storing tokens in Keychain
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    private let accessTokenKey = "com.fitness_assistant.accessToken"
    private let refreshTokenKey = "com.fitness_assistant.refreshToken"
    
    private init() {}
    
    // MARK: - Save
    
    func saveAccessToken(_ token: String) -> Bool {
        return save(token, forKey: accessTokenKey)
    }
    
    func saveRefreshToken(_ token: String) -> Bool {
        return save(token, forKey: refreshTokenKey)
    }
    
    func saveTokens(accessToken: String, refreshToken: String) -> Bool {
        let accessSaved = saveAccessToken(accessToken)
        let refreshSaved = saveRefreshToken(refreshToken)
        return accessSaved && refreshSaved
    }
    
    // MARK: - Retrieve
    
    func getAccessToken() -> String? {
        return retrieve(forKey: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return retrieve(forKey: refreshTokenKey)
    }
    
    // MARK: - Delete
    
    func deleteAccessToken() -> Bool {
        return delete(forKey: accessTokenKey)
    }
    
    func deleteRefreshToken() -> Bool {
        return delete(forKey: refreshTokenKey)
    }
    
    func deleteAllTokens() -> Bool {
        let accessDeleted = deleteAccessToken()
        let refreshDeleted = deleteRefreshToken()
        return accessDeleted && refreshDeleted
    }
    
    // MARK: - Private Methods
    
    private func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        // Delete any existing item
        delete(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    private func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
