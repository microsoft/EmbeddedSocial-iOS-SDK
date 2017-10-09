//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct APIBasePathSetupCommand: Command {
    
    func execute() {
        EmbeddedSocialClientAPI.basePath = UITestsHelper.mockServerPath ?? Constants.API.ppeBasePath
    }
}
