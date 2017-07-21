//
//  CredentialsList+Memento.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension CredentialsList: MementoSerializable {
    init?(memento: Memento) {
        guard let rawProvider = memento["provider"] as? Int,
            let provider = AuthProvider(rawValue: rawProvider),
            let accessToken = memento["accessToken"] as? String,
            let appKey = memento["appKey"] as? String,
            let socialUID = memento["socialUID"] as? String
            else {
                return nil
        }
        
        self.provider = provider
        self.accessToken = accessToken
        self.appKey = appKey
        self.socialUID = socialUID
        requestToken = memento["requestToken"] as? String
    }
    
    var memento: Memento {
        let memento: [String: Any?] = [
            "provider": provider.rawValue,
            "accessToken": accessToken,
            "requestToken": requestToken,
            "appKey": appKey,
            "socialUID": socialUID
        ]
        
        return memento.flatMap { $0 }
    }
}
