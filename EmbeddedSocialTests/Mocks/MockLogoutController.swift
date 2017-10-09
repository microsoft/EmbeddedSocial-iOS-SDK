//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockLogoutController: LogoutController {
    private(set) var logOutCount = 0
    private(set) var logOutWithErrorCount = 0
    private(set) var logOutError: Error?
    
    func logOut() {
        logOutCount += 1
    }
    
    func logOut(with error: Error) {
        logOutWithErrorCount += 1
        logOutError = error
    }
}
