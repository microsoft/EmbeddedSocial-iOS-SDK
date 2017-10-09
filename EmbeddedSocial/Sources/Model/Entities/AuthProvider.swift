//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum AuthProvider: Int {
    case facebook
    case microsoft
    case google
    case twitter
    
    static let all: [AuthProvider] = [.facebook, .microsoft, .google, .twitter]
}

extension AuthProvider {
    var name: String {
        let all: [AuthProvider: String] = [
            .facebook: "Facebook",
            .microsoft: "Microsoft",
            .google: "Google",
            .twitter: "Twitter"
        ]
        guard let name = all[self] else {
            fatalError("Unknown provider name")
        }
        return name
    }
}
