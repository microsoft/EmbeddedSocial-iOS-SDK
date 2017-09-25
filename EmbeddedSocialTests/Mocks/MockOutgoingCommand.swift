//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockOutgoingCommand: OutgoingCommand {
    
    let uid: String
    
    init(uid: String = UUID().uuidString) {
        self.uid = uid
        super.init(json: [:])!
    }
    
    required init(json: [String : Any]) {
        self.uid = UUID().uuidString
        super.init(json: [:])!
    }
}

