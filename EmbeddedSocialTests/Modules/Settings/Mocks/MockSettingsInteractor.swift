//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

final class MockSettingsInteractor: SettingsInteractorInput {
    private(set) var switchVisibilityCount = 0
    private(set) var signOutCount = 0
    var switchVisibilityReturnValue: Result<Visibility>?
    
    func switchVisibility(_ visibility: Visibility, completion: @escaping (Result<Visibility>) -> Void) {
        switchVisibilityCount += 1
        if let result = switchVisibilityReturnValue {
            completion(result)
        }
    }
    
    func signOut() {
        signOutCount += 1
    }
}
