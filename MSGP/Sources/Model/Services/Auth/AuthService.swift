//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AuthServiceType {
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void)
}

protocol AuthAPI {
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void)
}

protocol AuthAPIProviderType {
    func api(for provider: AuthProvider) -> AuthAPI
}
