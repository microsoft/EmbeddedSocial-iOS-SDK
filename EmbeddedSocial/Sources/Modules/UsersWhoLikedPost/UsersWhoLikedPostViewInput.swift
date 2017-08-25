//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UsersWhoLikedPostViewInput: class {
    func setupInitialState(userListView: UIView)

    func showError(_ error: Error)
}
