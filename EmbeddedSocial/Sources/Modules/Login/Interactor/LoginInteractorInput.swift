//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol LoginInteractorInput {
    func login(provider: AuthProvider, from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void)
    
    func getMyProfile(socialUser: SocialUser,
                      from viewController: UIViewController?,
                      handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
}
