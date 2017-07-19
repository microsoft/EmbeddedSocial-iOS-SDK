//
//  AuthProvider.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

enum AuthProvider: Int {
    case facebook
    case microsoft
    case google
    case twitter
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
