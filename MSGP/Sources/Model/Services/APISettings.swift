//
//  APISettings.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class APISettings {
    static let shared = APISettings()
    
    private let queue = DispatchQueue(label: "APISettings queue")

    private init() {
        EmbeddedSocialClientAPI.basePath = Keys.ppeBasePath
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
