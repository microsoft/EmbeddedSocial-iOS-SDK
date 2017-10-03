//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockDetailedActivityViewController: DetailedActivityViewInput {
    var output: DetailedActivityViewOutput!
    
    var reloadAllContentCount = 0
    func reloadAllContent() {
        reloadAllContentCount += 1
    }
    
    var setErrorTextCount = 0
    func setErrorText(text: String) {
        setErrorTextCount += 1
    }
    
    var setupInitialStateCount = 0
    func setupInitialState() {
        setupInitialStateCount += 1
    }
}
