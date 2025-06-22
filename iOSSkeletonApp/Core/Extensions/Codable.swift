//
//  Codable.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

// Extension to provide utility methods for types conforming to `Encodable`.
extension Encodable {
    /// Converts an `Encodable` object to a dictionary representation that can be posted or used in APIs.
    ///
    /// - Parameters:
    ///   - encoder: A `JSONEncoder` instance to encode the object (default is `JSONEncoder()`).
    /// - Throws: Throws an error if encoding or JSON serialization fails.
    /// - Returns: A dictionary representation of the object.
    public func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        
        let object = try JSONSerialization.jsonObject(with: data)
        
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        
        return json
    }
    
    /// Converts an `Encodable` object to `Data`.
    ///
    /// - Parameters:
    ///   - encoder: A `JSONEncoder` instance to encode the object (default is `JSONEncoder()`).
    /// - Returns: The encoded `Data`, or `nil` if an error occurs during encoding.
    public func toData(_ encoder: JSONEncoder = JSONEncoder()) -> Data? {
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

// Extension to provide utility methods for types conforming to `Decodable`.
extension Decodable {
    // Alias for a dictionary with `AnyHashable` keys and `Any` values.
    public typealias Dictionary = [AnyHashable: Any]
    
    /// Converts a dictionary to a `Decodable` object.
    ///
    /// - Parameters:
    ///   - type: The target type that conforms to `Decodable`.
    ///   - json: A dictionary representation of the object.
    /// - Returns: A `Decodable` object of the specified type, or `nil` if decoding fails.
    public static func toObject<Target>(type: Target.Type, from json: Dictionary) -> Target? where Target: Decodable {
        if let data = json.toData {
            do {
                let object = try JSONDecoder().decode(type, from: data)
                return object
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    /// Converts `Data` to a `Decodable` object.
    ///
    /// - Parameters:
    ///   - type: The target type that conforms to `Decodable`.
    ///   - data: The `Data` representation of the object.
    /// - Returns: A `Decodable` object of the specified type, or `nil` if decoding fails.
    public static func toObject<Target>(type: Target.Type, from data: Data) -> Target? where Target: Decodable {
        do {
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
