//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol LinkedAccountsInteractorInput: class {
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void)
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               completion: @escaping (Result<Authorization>) -> Void)
    
    func linkAccount(provider: AuthProvider, authorization: Authorization, completion: @escaping (Result<Void>) -> Void)
    
    func deleteLinkedAccount(provider: AuthProvider, completion: @escaping (Result<Void>) -> Void)
}
