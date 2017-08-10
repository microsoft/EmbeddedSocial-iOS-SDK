//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Localizator {
    
    static func localize(_ key: String, _ args: CVarArg...) -> String {
        
        let format = NSLocalizedString(
            key,
            tableName: nil,
            bundle: Bundle(for: self),
            comment: "")

        let result = withVaList(args){
             (NSString(format: format, locale: Locale.current, arguments: $0) as String)
        }

        return result
    }
    
}
