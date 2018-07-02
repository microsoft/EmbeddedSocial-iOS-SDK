//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension String {
    var dateFromISO: Date? {
        return Formatter.ISOString.date(from: self)
    }
    
    mutating func replace(target: String, withString: String) {
        self = self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
