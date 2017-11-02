//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol DateFormatterProtocol {
    func timeAgo(since: Date) -> String?
}

class DateFormatterTool: DateFormatterProtocol {
    
    static let shared: DateFormatterProtocol = DateFormatterTool()
    
    func timeAgo(since then: Date) -> String? {
        let now = Date()
        let interval: TimeInterval = now.timeIntervalSince(then)
        return DateFormatterTool.short.string(from: interval)
    }
    
    static let short: DateComponentsFormatter = {
        
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.includesApproximationPhrase = false
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        return formatter
    }()
    
}
