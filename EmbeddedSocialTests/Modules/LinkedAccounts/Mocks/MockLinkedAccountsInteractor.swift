//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockLinkedAccountsInteractor: LinkedAccountsInteractorInput {

    //MARK: - getLinkedAccounts
    
    var getLinkedAccountsCompletionCalled = false
    var getLinkedAccountsCompletionReturnValue: Result<[LinkedAccountView]>!
    
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void) {
        getLinkedAccountsCompletionCalled = true
        completion(getLinkedAccountsCompletionReturnValue)
    }
    
    //MARK: - login
    
    var loginWithFromCompletionCalled = false
    var loginWithFromCompletionReceivedArguments: (provider: AuthProvider, viewController: UIViewController?)?
    var loginWithFromCompletionReturnValue: Result<Authorization>!

    func login(with provider: AuthProvider, from viewController: UIViewController?, completion: @escaping (Result<Authorization>) -> Void) {
        loginWithFromCompletionCalled = true
        loginWithFromCompletionReceivedArguments = (provider: provider, viewController: viewController)
        completion(loginWithFromCompletionReturnValue)
        
    }
    
    //MARK: - linkAccount
    
    var linkAccountAuthorizationCompletionCalled = false
    var linkAccountAuthorizationCompletionReceivedArguments: (provider: AuthProvider, authorization: Authorization)?
    var linkAccountAuthorizationCompletionReturnValue: Result<Void>!
    
    func linkAccount(provider: AuthProvider, authorization: Authorization, completion: @escaping (Result<Void>) -> Void) {
        linkAccountAuthorizationCompletionCalled = true
        linkAccountAuthorizationCompletionReceivedArguments = (provider, authorization)
        completion(linkAccountAuthorizationCompletionReturnValue)
    }
    
    //MARK: - deleteLinkedAccount
    
    var deleteLinkedAccountProviderCompletionCalled = false
    var deleteLinkedAccountProviderCompletionReceivedProvider: AuthProvider?
    var deleteLinkedAccountProviderCompletionReturnValue: Result<Void>!

    func deleteLinkedAccount(provider: AuthProvider, completion: @escaping (Result<Void>) -> Void) {
        deleteLinkedAccountProviderCompletionCalled = true
        deleteLinkedAccountProviderCompletionReceivedProvider = provider
        completion(deleteLinkedAccountProviderCompletionReturnValue)
    }
    
}
