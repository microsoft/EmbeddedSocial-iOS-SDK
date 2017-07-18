//
//  EmbeddedSocialClientAPIAdaptor.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class EmbeddedSocialClientAPIAdaptor {
    static let shared = EmbeddedSocialClientAPIAdaptor()
    
    private let queue = DispatchQueue(label: "EmbeddedSocialClientAPIAdaptor queue")

    private init() { }
    
    var customHeaders: [String: String] {
        set {
            queue.async { EmbeddedSocialClientAPI.customHeaders = newValue }
        }
        get {
            return queue.sync { EmbeddedSocialClientAPI.customHeaders }
        }
    }
}
