//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension DateFormatter {
    
    func timeSince(from: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.weekOfYear, .day, .hour, .minute, .second], from: from, to: now)
        
        var result = ""
        
        if components.weekOfYear! > 0 {
            result = "\(components.weekOfYear!)w"
        } else if components.day! > 0 {
            result = "\(components.day!)d"
        } else if components.hour! > 0 {
            result = "\(components.hour!)h"
        } else if components.minute! > 0 {
            result = "\(components.minute!)m"
        } else if components.second! >= 10 {
            result = "\(components.second!)s"
        } else {
            result = "Just now"
        }
        
        return result
    }
}
