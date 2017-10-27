//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol SuggestedUsersInteractorInput: class {
    var isFriendsListPermissionGranted: Bool { get }
    
    func requestFriendsListPermission(parentViewController vc: UIViewController?,
                                      completion: @escaping (Result<CredentialsList>) -> Void)
}
