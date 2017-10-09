//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

struct MockAuthAPI: AuthAPI {
    private let result: Result<SocialUser>
    
    init(resultToReturn: Result<SocialUser>) {
        result = resultToReturn
    }
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        handler(result)
    }
}
