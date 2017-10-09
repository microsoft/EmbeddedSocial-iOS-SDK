//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockAppConfiguration: AppConfigurationType {
    
    var theme: Theme = {
        let config = ["name": "dark", "accentColor": "#ffffff"]
        return Theme(config: config)!
    }()
    
}
