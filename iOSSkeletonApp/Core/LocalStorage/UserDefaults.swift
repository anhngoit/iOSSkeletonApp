//
//  UserDefaults.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import os

@propertyWrapper
public final class UserDefault<T> where T: Codable {
    private(set) var key: String
    let defaultValue: T?
    private var userDefault: UserDefaults

    public init(_ key: String,
                defaultValue: T?,
                userDefault: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefault = userDefault
    }

    public var wrappedValue: T? {
        get {
            let value = userDefault.object(forKey: key)
            if value is Data { // -- Array, enum, class, struct type
                let obj = T.toObject(type: T.self, from: value as? Data ?? Data())
                if obj != nil {
                    AppLogger.localStorage.info("UserDefault: Successfully retrieved value for key: \(self.key, privacy: .public)")
                } else {
                    AppLogger.localStorage.warning("UserDefault: Failed to decode value for key: \(self.key, privacy: .public)")
                }
                return obj ?? defaultValue
            } else { // -- primitive type: Int, String, Double, Bool
                let primitiveValue = (value as? T) ?? defaultValue
                if primitiveValue != nil {
                    AppLogger.localStorage.info("UserDefault: Successfully retrieved primitive value for key: \(self.key, privacy: .public)")
                } else {
                    AppLogger.localStorage.warning("UserDefault: Value for key: \(self.key, privacy: .public) is nil, using default.")
                }
                return primitiveValue
            }
        }
        set {
            AppLogger.localStorage.info("UserDefault: Setting value for key: \(self.key, privacy: .public)")
            if (newValue is String) || (newValue is Int) || (newValue is Double) || (newValue is Bool) || (newValue is Data) {
                userDefault.set(newValue, forKey: key)
                AppLogger.localStorage.info("UserDefault: Primitive value successfully set for key: \(self.key, privacy: .public)")
            } else {
                let newData = newValue?.toData()
                if newData != nil {
                    AppLogger.localStorage.info("UserDefault: Complex value successfully encoded and set for key: \(self.key, privacy: .public)")
                } else {
                    AppLogger.localStorage.error("UserDefault: Failed to encode complex value for key: \(self.key, privacy: .public)")
                }
                userDefault.set(newData, forKey: key)
            }
            userDefault.synchronize()
        }
    }
    
    public var projectedValue: UserDefault<T> {
        return self
    }
    
    public func setKey(_ key: String) {
        AppLogger.localStorage.info("UserDefault: Changing key from \(self.key, privacy: .public) to \(key, privacy: .public)")
        self.key = key
    }
}

/*
    ///1. Define Properties Using the Wrapper
     class AppSettings {
         @UserDefault("userKey", defaultValue: nil)
         var user: User?

         @UserDefault("isDarkMode", defaultValue: false)
         var isDarkMode: Bool?

         @UserDefault("username", defaultValue: "Guest")
         var username: String?
     }

     struct User: Codable {
         let name: String
         let age: Int
     }
 
    ///2. Save and Retrieve Data
     let settings = AppSettings()

     // Save a custom Codable object
     let user = User(name: "John Doe", age: 25)
     settings.user = user

     // Save a primitive type
     settings.isDarkMode = true

     // Save a string
     settings.username = "johndoe"
    

     // Retrieve a custom Codable object
     if let savedUser = settings.user {
         print("User Name: \(savedUser.name), Age: \(savedUser.age)")
     } else {
         print("No user found.")
     }

     // Retrieve a primitive type
     if let isDarkMode = settings.isDarkMode {
         print("Dark Mode Enabled: \(isDarkMode)")
     }

     // Retrieve a string
     print("Username: \(settings.username ?? "Unknown")")
*/
