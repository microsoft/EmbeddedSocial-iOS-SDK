//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

final class MockSettingsInteractor: SettingsInteractorInput {
    
    //MARK: - switchVisibility

    private(set) var switchVisibilityCount = 0
    var switchVisibilityReturnValue: Result<Visibility>?
    
    func switchVisibility(_ visibility: Visibility, completion: @escaping (Result<Visibility>) -> Void) {
        switchVisibilityCount += 1
        if let result = switchVisibilityReturnValue {
            completion(result)
        }
    }
    
    //MARK: - signOut

    private(set) var signOutCount = 0
    
    func signOut() {
        signOutCount += 1
    }
    
    //MARK: - deleteAccount

    var deleteAccountCalled = false
    var deleteAccountResult: Result<Void>!
    
    func deleteAccount(completion: @escaping (Result<Void>) -> Void) {
        deleteAccountCalled = true
        completion(deleteAccountResult)
    }
    
    //MARK: - deleteSearchHistory
    
    var deleteSearchHistoryCalled = false
    
    func deleteSearchHistory() {
        deleteSearchHistoryCalled = true
    }
}
