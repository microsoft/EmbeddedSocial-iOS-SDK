//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class RootConfigurator {
    
    let router: RootRouter
    
    init(window: UIWindow) {
        router = RootRouter(window: window)
    }
}
