//
//  Dictionary.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

extension Dictionary {
    /// Converts the dictionary into encoded `Data` using UTF-8 encoding.
    ///
    /// - Returns: The `Data` representation of the dictionary, or `nil` if encoding fails.
    public var toData: Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Updates the current dictionary with the key-value pairs from another dictionary.
    ///
    /// - Parameter other: The dictionary whose key-value pairs are added or updated in the current dictionary.
    public mutating func update(other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}
