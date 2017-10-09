//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Logger {
    
    enum LogEvent: String {
        case error = "⚠️"
        case verbose = "💬"
        case important = "🔥"
        case veryImportant = "🔥🔥🔥"
        case fire = "🔥🔥🔥🔥🔥🔥🔥🔥"
    }
    
    class func log(_ something: Any?...,
                    event: LogEvent = .verbose,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        #if DEBUG
            if event == logLevel || logLevel == nil {
                print("\(now()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(funcName) -> \(String(describing: something))")
            }
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    static var logLevel: LogEvent? = .veryImportant
    static var dateFormat = "HH:mm:ss"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    static func now() -> String {
        return dateFormatter.string(from: Date())
    }
}

