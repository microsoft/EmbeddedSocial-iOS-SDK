//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class AuthService: AuthServiceType {
    private let apiProvider: AuthAPIProviderType
    private var apis: [AuthProvider: AuthAPI] = [:]
    
    init(apiProvider: AuthAPIProviderType) {
        self.apiProvider = apiProvider
    }
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void) {
        api(for: provider).login(from: viewController) { result in
            handler(result)
        }
    }
    
    private func api(for provider: AuthProvider) -> AuthAPI {
        if let api = apis[provider] {
            return api
        } else {
            let api = apiProvider.api(for: provider)
            apis[provider] = api
            return api
        }
    }
}
