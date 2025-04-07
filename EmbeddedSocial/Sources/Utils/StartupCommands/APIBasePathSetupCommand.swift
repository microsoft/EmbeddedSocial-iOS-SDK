//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct APIBasePathSetupCommand: Command {
    
    private let basePath: String
    
    init(basePath: String) {
        self.basePath = basePath
    }
    
    func execute() {
        EmbeddedSocialClientAPI.basePath = basePath
    }
}
