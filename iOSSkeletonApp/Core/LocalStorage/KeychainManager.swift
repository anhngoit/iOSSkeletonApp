//
//  KeychainManager.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Security
import Foundation
import os

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    // MARK: - Save Data to Keychain
    @discardableResult
    func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            AppLogger.localStorage.error("Failed to convert value to data for key \(key, privacy: .public)")
            return false
        }
        
        // Delete existing item before saving to avoid duplicates
        if delete(forKey: key) {
            AppLogger.localStorage.info("Existing key \(key, privacy: .public) deleted before saving.")
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            AppLogger.localStorage.info("Successfully saved value for key \(key, privacy: .public)")
        } else {
            AppLogger.localStorage.error("Failed to save value for key \(key, privacy: .public). Status: \(status)")
        }
        return status == errSecSuccess
    }
    
    // MARK: - Retrieve Data from Keychain
    func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            AppLogger.localStorage.info("Successfully retrieved value for key \(key, privacy: .public)")
            return value
        } else {
            AppLogger.localStorage.error("Failed to retrieve value for key \(key, privacy: .public). Status: \(status)")
            return nil
        }
    }
    
    // MARK: - Delete Data from Keychain
    @discardableResult
    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            AppLogger.localStorage.info("Successfully deleted value for key \(key, privacy: .public)")
        } else {
            AppLogger.localStorage.error("Failed to delete value for key \(key, privacy: .public). Status: \(status)")
        }
        return status == errSecSuccess
    }
    
    // MARK: - Update Existing Data in Keychain
    @discardableResult
    func update(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            AppLogger.localStorage.error("Failed to convert value to data for key \(key, privacy: .public)")
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecSuccess {
            AppLogger.localStorage.info("Successfully updated value for key \(key, privacy: .public)")
        } else {
            AppLogger.localStorage.error("Failed to update value for key \(key, privacy: .public). Status: \(status)")
        }
        return status == errSecSuccess
    }
}
