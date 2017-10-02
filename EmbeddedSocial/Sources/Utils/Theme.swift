//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Theme {
    
    init?(filename: String) {
        Bundle(for: type(of: self)).path(forResource: filename, ofType: <#T##String?#>)
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
    }
}
