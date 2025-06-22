//
//  Date.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

extension Date {
    
    /// Converts a date string into a `Date` object based on a custom date format.
    ///
    /// - Parameters:
    ///   - string: The string representing the date.
    ///   - dateFormat: The format of the date string. Defaults to "yyyy-MM-dd".
    /// - Returns: A `Date` object if the conversion is successful; otherwise, `nil`.
    static func stringToDate(string: String, withCustomDateFormat dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        return dateFormatter.date(from: string)
    }
    
    /// Converts the current `Date` instance into a string based on a custom date format.
    ///
    /// - Parameter dateFormat: The desired format for the output string. Defaults to "yyyy-MM-dd".
    /// - Returns: A string representation of the `Date`.
    func toString(withCustomDateFormat dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        return dateFormatter.string(from: self)
    }
    
    /// Current date
    ///
    /// - Parameters:
    ///   - returns: current date
    static func now() -> Date {
        return Date()
    }
    
    /// Yesterday date at same time
    ///
    /// - Parameters:
    ///   - returns: yesterday date
    static func yesterday() -> Date {
        return Date(timeIntervalSinceNow: -24 * 60 * 60)
    }
}
