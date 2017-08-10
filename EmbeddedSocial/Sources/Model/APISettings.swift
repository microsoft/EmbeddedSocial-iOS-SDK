//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class APISettings {
    static let shared = APISettings()
    
    private let queue = DispatchQueue(label: "APISettings queue")

    private init() {
        EmbeddedSocialClientAPI.basePath = UITestsHelper.mockServerPath ?? Keys.ppeBasePath
    }
    
    var customHeaders: [String: String] {
        set {
            queue.async { EmbeddedSocialClientAPI.customHeaders = newValue }
        }
        get {
            return queue.sync { EmbeddedSocialClientAPI.customHeaders }
        }
    }
}

fileprivate extension APISettings {
    struct Keys {
        static let productionBasePath = "https://api.embeddedsocial.microsoft.com"
        static let ppeBasePath = "https://ppe.embeddedsocial.microsoft.com"
    }
}
