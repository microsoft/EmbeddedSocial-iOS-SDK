//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

func getEnvironmentVariable(_ name: String) -> String? {
    guard let rawValue = getenv(name) else {
        return nil
    }
    return String(utf8String: rawValue)
}
