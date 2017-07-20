//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import MSGP

struct MockAuthAPIProvider: AuthAPIProviderType {
    private let api: AuthAPI
    
    init(apiToProvide: AuthAPI) {
        api = apiToProvide
    }
    
    func api(for provider: AuthProvider) -> AuthAPI {
        return api
    }
}
