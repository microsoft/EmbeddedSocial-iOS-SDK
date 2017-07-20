//
//  ISODate.swift
//  MSGP
//
//  Created by Akvelon on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension Formatter {
    static let ISOString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    var ISOString: String {
        return Formatter.ISOString.string(from: self)
    }
}

extension String {
    var dateFromISO: Date? {
        return Formatter.ISOString.date(from: self)
    }
    
    mutating func replace(target: String, withString: String) {
        self = self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
