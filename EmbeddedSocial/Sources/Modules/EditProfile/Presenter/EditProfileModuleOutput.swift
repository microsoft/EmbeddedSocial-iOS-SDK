//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol EditProfileModuleOutput: class {
    var viewController: UIViewController? { get }
    
    func setRightNavigationButtonEnabled(_ isEnabled: Bool)
}
