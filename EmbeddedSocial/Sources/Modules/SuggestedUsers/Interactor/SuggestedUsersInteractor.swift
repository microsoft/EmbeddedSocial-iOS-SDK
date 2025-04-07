//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SuggestedUsersInteractor: SuggestedUsersInteractorInput {
    
    var isFriendsListPermissionGranted: Bool {
        return facebookAPI.hasGrantedFriendsListPermission
    }
    
    private let facebookAPI: FacebookAPI
    
    init(facebookAPI: FacebookAPI) {
        self.facebookAPI = facebookAPI
    }
    
    func requestFriendsListPermission(parentViewController vc: UIViewController?,
                                      completion: @escaping (Result<CredentialsList>) -> Void) {
        facebookAPI.login(from: vc) { result in
            completion(result.map { $0.credentials })
        }
    }
}
