//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockThirdPartyConfigurator: ThirdPartyConfiguratorType {
    private(set) var setupCount = 0
    
    func setup(application: UIApplication, launchOptions: [AnyHashable : Any]) {
        setupCount += 1
    }
}
