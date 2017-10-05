//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ThirdPartiesConfigurationCommand: Command {
    private let configurator: ThirdPartyConfiguratorType
    private let launchArgs: LaunchArguments
    
    init(configurator: ThirdPartyConfiguratorType, launchArgs: LaunchArguments) {
        self.configurator = configurator
        self.launchArgs = launchArgs
    }
    
    func execute() {
        configurator.setup(application: launchArgs.app, launchOptions: launchArgs.launchOptions)
    }
}
