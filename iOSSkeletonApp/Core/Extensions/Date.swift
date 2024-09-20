//
//  Date.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/06/2024.
//

import Foundation

extension Date {
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
}
