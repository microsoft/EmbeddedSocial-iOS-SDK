//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UITestsHelper {
    
    static private let mockServerPathKey = "EmbeddedSocial_MOCK_SERVER"
    
    static let isRunningTests = mockServerPath != nil
    
    static func getEnvironmentVariable(_ name: String) -> String? {
        guard let rawValue = getenv(name) else {
            return nil
        }
        return String(utf8String: rawValue)
    }
    
    static var mockUser: User {
        let creds = CredentialsList(provider: .facebook,
                                    accessToken: "AccessToken",
                                    requestToken: "RequestToken",
                                    socialUID: UUID().uuidString,
                                    appKey: "AppKey")
        
        return User(uid: UUID().uuidString,
                    firstName: "John",
                    lastName: "Doe",
                    email: "jonh.doe@contoso.com",
                    bio: "Lorem ipsum dolor",
                    photo: Photo(image:(UIImage(asset: .userPhotoPlaceholder))),
                    credentials: creds)
    }
    
    static var mockSessionToken: String {
        return "SessionToken"
    }
    
    static var mockServerPath: String? {
        return getEnvironmentVariable(mockServerPathKey)
    }
}
