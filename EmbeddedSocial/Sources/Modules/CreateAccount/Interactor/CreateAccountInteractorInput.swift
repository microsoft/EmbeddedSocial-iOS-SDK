//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CreateAccountInteractorInput {
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
}
