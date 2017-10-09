//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockThirdPartyConfigurator: ThirdPartyConfiguratorType {
    
    //MARK: - setup
    
    var setupApplicationLaunchOptionsCalled = false
    var setupApplicationLaunchOptionsReceivedArguments: (application: UIApplication, launchOptions: [AnyHashable: Any])?
    
    func setup(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        setupApplicationLaunchOptionsCalled = true
        setupApplicationLaunchOptionsReceivedArguments = (application: application, launchOptions: launchOptions)
    }
    
}
