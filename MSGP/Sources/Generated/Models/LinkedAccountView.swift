//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Linked account view */
open class LinkedAccountView: JSONEncodable {
    public enum IdentityProvider: String { 
        case facebook = "Facebook"
        case microsoft = "Microsoft"
        case google = "Google"
        case twitter = "Twitter"
        case aads2s = "AADS2S"
        case socialPlus = "SocialPlus"
    }
    /** Gets or sets identity provider type */
    public var identityProvider: IdentityProvider?
    /** Gets or sets third party account id -- Unique user id provided by the third-party identity provider */
    public var accountId: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["identityProvider"] = self.identityProvider?.rawValue
        nillableDictionary["accountId"] = self.accountId
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
