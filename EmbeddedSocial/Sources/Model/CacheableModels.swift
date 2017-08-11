//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Photo: Cacheable {
    func encodeToJSON() -> Any {
        return self.memento
    }
    
    var handle: String { return uid }
}

extension UserProfileView: Cacheable {
    var handle: String { return userHandle! }
}

extension PostTopicRequest: Cacheable { }
