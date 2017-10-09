//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class DateFormatterTool {
    
    lazy var shortStyle: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.includesApproximationPhrase = false
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        return formatter
    }()
    
    static func timeAgo(since: Date) -> String? {
        return short.string(from: since, to: Date())
    }
    
    static var short:DateComponentsFormatter {
        
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.includesApproximationPhrase = false
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        return formatter
    }
    
}
