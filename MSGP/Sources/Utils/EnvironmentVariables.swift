//
//  EnvironmentVariables.swift
//  MSGP
//
//  Created by Akvelon on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

func getEnvironmentVariable(_ name: String) -> String? {
    guard let rawValue = getenv(name) else {
        return nil
    }
    return String(utf8String: rawValue)
}
