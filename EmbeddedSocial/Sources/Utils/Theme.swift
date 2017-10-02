//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Theme {
    
    let config: [String: Any]
    
    init?(filename: String) {
        guard let path = Bundle(for: type(of: self)).path(forResource: filename, ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                return nil
        }
        self.config = config
        load()
    }
    
    func load() {
        print(config["contentBackground"])
    }
}
